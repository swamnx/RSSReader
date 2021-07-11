//
//  FeedController.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import UIKit

class FeedController: UIViewController {
    
    class FeedInitParams {
        var existedFeed: FeedUi?
    }
    
    var params = FeedInitParams()
    
    @IBOutlet weak var newsView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsView.dataSource = self
        newsView.delegate = self
        newsView.reloadData()
    }
}

//
// MARK: Table view data source
//
extension FeedController: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return params.existedFeed!.news.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCellId", for: indexPath)
        cell.textLabel?.text = params.existedFeed?.news[indexPath.row].title
        return cell
    }
}
