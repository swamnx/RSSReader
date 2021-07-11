//
//  ViewController.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import UIKit

class FeedsAndFoldersController: UITableViewController {

    var feedService =  RealmFeedService.shared!
    var folderServie =  RealmFolderService.shared!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
         tableView.reloadData()
     }
    
    private func getUniversalItems() -> [UniversalItemUi] {
        var universalItems = [UniversalItemUi]()
        universalItems.append(contentsOf: feedService.loadAllWithoutFolders().map({UniversalItemUi.init(feed: $0, folder: nil)}))
        universalItems.append(contentsOf: folderServie.loadAll().map({UniversalItemUi.init(feed: nil, folder: $0)}))
        return universalItems
    }

}

//
// MARK: Table view data source
//
extension FeedsAndFoldersController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getUniversalItems().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UniversalItemCellId", for: indexPath)
        let item = getUniversalItems()[indexPath.row]
        if item.feed != nil {
            cell.textLabel?.text = item.feed!.getCellText()
            cell.imageView?.image = item.feed!.icon?.imageResized(to: .init(width: 53, height: 30))
        }
        if item.folder != nil {
            cell.imageView?.image = nil
            cell.textLabel?.text = item.folder!.title
        }
        return cell
    }

}
//
// MARK: Table View Cell Default Swipe Actions
//
extension FeedsAndFoldersController {
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] (_, _, _) in
            let item = getUniversalItems()[indexPath.row]
            if item.feed != nil {
                self.navigationController?.pushViewController(getAddOrEditFeedController(feed: item.feed, add: false), animated: true)
            }
            if item.folder != nil {
                self.navigationController?.pushViewController(getEditFolderController(folder: item.folder!), animated: true)
            }
        }
        editAction.backgroundColor = UIColor.systemYellow
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (_, _, _) in
            let item = getUniversalItems()[indexPath.row]
            var succesfull = false
            if item.feed != nil {
                succesfull = succesfull || self.feedService.removeById(id: item.feed!.id)
            }
            if item.folder != nil {
                succesfull = succesfull || self.folderServie.removeById(id: item.folder!.id)
            }
            if succesfull {
                tableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
//
// MARK: Bar Actions
//
extension FeedsAndFoldersController {
    
    @IBAction func plusTapped(_ sender: UIBarButtonItem) {
        self.present(getAddFolderOrFeedAlertController(), animated: true, completion: nil)
    }
    
}

//
// MARK: Selection and Deselection actions
//
extension FeedsAndFoldersController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = getUniversalItems()[indexPath.row]
        if item.feed != nil {
            self.navigationController?.pushViewController(getFeedController(feed: item.feed!), animated: true)
        }
        if item.folder != nil {
            self.navigationController?.pushViewController(getFolderController(folder: item.folder!), animated: true)
        }
    }
}

//
// MARK: Private Custom UI Controllers
//
extension FeedsAndFoldersController {
    
    private func getAddOrEditFeedController(feed: FeedUi?, add: Bool) -> AddOrEditFeedController {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddOrEditFeedControllerId") as? AddOrEditFeedController
        controller!.params.add = add
        controller!.params.existedFeed = feed
        return controller!
    }
    
    private func getEditFolderController(folder: FolderUi) -> EditFolderController {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditFolderControllerId") as? EditFolderController
        controller!.params.existedFolder = folder
        return controller!
    }
    
    private func getFeedController(feed: FeedUi) -> FeedController {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedControllerId") as? FeedController
        controller!.params.existedFeed = feed
        return controller!
    }
    
    private func getFolderController(folder: FolderUi) -> FolderController {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FolderControllerId") as? FolderController
        controller!.params.existedFolder = folder
        return controller!
    }
    
    private func getAddFolderAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Add New Folder", message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Folder Name"
        }

        let saveAction = UIAlertAction(title: "Add", style: .default, handler: { [unowned self] _ -> Void in
            let textField = alertController.textFields![0] as UITextField
            guard let writtenText = textField.text else { return }
            if writtenText.isEmpty { return }
            let folderForSaving = FolderSave.init(title: writtenText)
            if self.folderServie.save(folder: folderForSaving) != nil {
                self.tableView.reloadData()
            }
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil )

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        return alertController
    }
    
    private func getAddFolderOrFeedAlertController() -> UIAlertController {
        let alertController = UIAlertController(title: "Add New Folder or Feed", message: nil, preferredStyle: .alert)

        let addFolder = UIAlertAction(title: "Add Folder", style: .default, handler: { [unowned self] _ -> Void in
            self.present(getAddFolderAlertController(), animated: true, completion: nil)
        })
        let addFeed = UIAlertAction(title: "Add Feed", style: .default, handler: { [unowned self] _ -> Void in
            self.navigationController?.pushViewController(getAddOrEditFeedController(feed: nil, add: true), animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil )

        alertController.addAction(addFolder)
        alertController.addAction(addFeed)
        alertController.addAction(cancelAction)
        return alertController
    }
    
}
