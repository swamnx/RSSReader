//
//  EditFolderController.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import UIKit

class EditFolderController: UIViewController {
    
    @IBOutlet weak var folderNameView: UILabel!
    @IBOutlet weak var feedsView: UITableView!
    @IBOutlet weak var feedsToAddView: UITableView!
    
    class AddFeedInitParams {
        var existedFolder: FolderUi?
    }
    
    var params = AddFeedInitParams()
    
    var feedService = DummyFeedService.shared
    var folderService = DummyFolderService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        folderNameView.text = params.existedFolder?.title
        feedsView.delegate = self
        feedsView.dataSource = self
        feedsToAddView.delegate = self
        feedsToAddView.dataSource = self
        feedsView.reloadData()
        feedsToAddView.reloadData()
    }
    
}
//
// MARK: Table view data source
//
extension EditFolderController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == feedsView {
            return (params.existedFolder?.feeds.count)!
        }
        if tableView == feedsToAddView {
            return feedService.loadAllWithoutFolders().count
        }
        return 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == feedsView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCellId", for: indexPath)
            cell.textLabel?.text = params.existedFolder?.feeds[indexPath.row].title
            return cell
        }
        if tableView == feedsToAddView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FeedsToAddCellId", for: indexPath)
            cell.textLabel?.text = feedService.loadAllWithoutFolders()[indexPath.row].title
            return cell
        }
        return .init()
    }
}
//
// MARK: Table View Cell Default Swipe Actions
//
extension EditFolderController {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == feedsView {
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (action, view, bool) in
                let feedToDelete = params.existedFolder!.feeds[indexPath.row]
                let succesfull =  self.folderService.removeFeedById(folderId: params.existedFolder!.id, feedId: feedToDelete.id)
                if succesfull {
                    params.existedFolder!.feeds.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.feedsToAddView.reloadData()
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return UISwipeActionsConfiguration(actions: [])
    }
}
