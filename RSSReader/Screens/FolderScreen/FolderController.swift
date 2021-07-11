//
//  FolderViewController.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import UIKit

class FolderController: UIViewController {
    
    class EditFolderInitParams {
        var existedFolder: FolderUi?
    }
    
    var params = EditFolderInitParams()
    
    @IBOutlet weak var feedsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        feedsView.dataSource = self
        feedsView.delegate = self
        feedsView.reloadData()
    }
}

//
// MARK: Table view data source
//
extension FolderController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return params.existedFolder!.feeds.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCellId", for: indexPath)
        cell.textLabel?.text = params.existedFolder?.feeds[indexPath.row].title
        return cell
    }
}

//
// MARK: Selection and Deselection actions
//
extension FolderController {
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "FeedControllerId") as? FeedController
        controller!.params.existedFeed = params.existedFolder?.feeds[indexPath.row]
        self.navigationController?.pushViewController(controller!, animated: true)
    }
}