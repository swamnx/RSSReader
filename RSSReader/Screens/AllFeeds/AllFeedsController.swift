//
//  ViewController.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import UIKit

class AllFeedsController: UITableViewController {

    var feedService =  DummyFeedService.shared
    var folderServie =  DummyFolderService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
            cell.imageView?.image = item.feed!.icon
        }
        if item.folder != nil {
            cell.textLabel?.text = item.folder!.title
        }
        return cell
    }

}
