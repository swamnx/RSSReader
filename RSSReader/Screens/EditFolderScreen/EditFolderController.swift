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
    
    class EditFolderInitParams {
        var existedFolder: FolderUi?
    }
    
    var params = EditFolderInitParams()
    
    var feedService = RealmFeedService.shared!
    var folderService = RealmFolderService.shared!
    
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
            let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] (_, _, _) in
                let feedToDelete = params.existedFolder!.feeds[indexPath.row]
                if let folder =  self.folderService.removeFeed(folderId: params.existedFolder!.id, feedId: feedToDelete.id) {
                    params.existedFolder = folder
                    self.feedsToAddView.reloadData()
                    self.feedsView.reloadData()
                }
            }
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        return .init()
    }
}

//
// MARK: Selection action
//
extension EditFolderController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == feedsToAddView {
            let folderWithAddedFeed = folderService.addFeed(folderId: params.existedFolder!.id,
                                                          feedId: feedService.loadAllWithoutFolders()[indexPath.row].id
            )
            if folderWithAddedFeed != nil {
                params.existedFolder = folderWithAddedFeed
                self.feedsToAddView.reloadData()
                self.feedsView.reloadData()
            }
        }
    }
}
