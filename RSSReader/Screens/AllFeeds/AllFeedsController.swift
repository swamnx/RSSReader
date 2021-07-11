//
//  ViewController.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import UIKit

class AllFeedsController: UITableViewController {

    var feedService =  RealmFeedService.shared!
    var folderServie =  RealmFolderService.shared!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
         tableView.reloadData()
     }
    
    private func getUniversalItems() -> [UniversalItemUi] {
        var universalItems = [UniversalItemUi]()
        for feed in feedService.loadAllWithoutFolders() {
            let newUniversalItem = UniversalItemUi.init(feed: feed, folder: nil)
            universalItems.append(newUniversalItem)
        }
        for folder in folderServie.loadAll() {
            let newUniversalItem = UniversalItemUi.init(feed: nil, folder: folder)
            universalItems.append(newUniversalItem)
        }
        return universalItems
    }

}

//
// MARK: Table view data source
//
extension AllFeedsController {
    
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
extension AllFeedsController {
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [unowned self] (action, view, bool) in
            let item = getUniversalItems()[indexPath.row]
            if item.feed != nil {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddFeedControllerId") as? AddFeedController
                vc!.params.add = false
                vc!.params.existedFeed = item.feed!
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            if item.folder != nil {
                let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditFolderControllerId") as? EditFolderController
                vc!.params.existedFolder = item.folder!
                self.navigationController?.pushViewController(vc!, animated: true)
            }
            
        }
        editAction.backgroundColor = UIColor.systemYellow
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, view, bool) in
            let item = getUniversalItems()[indexPath.row]
            var succesfull = false
            if item.feed != nil {
                succesfull = succesfull || self.feedService.removeById(id: item.feed!.id)
            }
            if item.folder != nil {
                succesfull = succesfull || self.folderServie.removeById(id: item.folder!.id)
            }
            if succesfull {
                // tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

}
//
// MARK: Bar Actions
//
extension AllFeedsController {
    
    @IBAction func plusTapped(_ sender: UIBarButtonItem) {
        self.present(getAddFolderOrFeedAlertController(), animated: true, completion: nil)
    }
    
}

//
// MARK: Private Custom Alerts
//
extension AllFeedsController {
    
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
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "AddFeedControllerId") as? AddFeedController
            vc!.params.add = true
            self.navigationController?.pushViewController(vc!, animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil )

        alertController.addAction(addFolder)
        alertController.addAction(addFeed)
        alertController.addAction(cancelAction)
        return alertController
    }
}

//
// MARK: Selection and Deselection actions
//
extension AllFeedsController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = getUniversalItems()[indexPath.row]
        if item.feed != nil {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedControllerId") as? FeedController
            vc!.params.existedFeed = item.feed!
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        if item.folder != nil {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FolderControllerId") as? FolderController
            vc!.params.existedFolder = item.folder!
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
}
