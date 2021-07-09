//
//  DummyRssService.swift
//  RSSReader
//
//  Created by swamnx on 6.07.21.
//

import Foundation

class DummyRssService: RssServiceProtocol {
    
    func searchFeed(url: URL, completionHandler: (_ error: String?, _ data: SearchFeed?) -> Void) {
        let searchFeed = SearchFeed.init(icon: nil, title: "Test Feed record", url: URL.init(string: "https://www.nasa.gov/rss/dyn/breaking_news.rss")!, categories: ["dd646", "dd", "dfsfs"])
        completionHandler(nil, searchFeed)
    }
    
    func searchFeedWithoutCategories(url: URL, completionHandler: (_ error: String?, _ data: SearchFeed?) -> Void) {
        let searchFeed = SearchFeed.init(icon: nil, title: "Test Feed record", url: URL.init(string: "https://www.nasa.gov/rss/dyn/breaking_news.rss")!, categories: [])
        completionHandler(nil, searchFeed)
    }
    
    func searchFeedWithError(url: URL, completionHandler: (_ error: String?, _ data: SearchFeed?) -> Void) {
        completionHandler("dsss", nil)
    }
}
