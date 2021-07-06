//
//  DummyRssService.swift
//  RSSReader
//
//  Created by swamnx on 6.07.21.
//

import Foundation

class DummyRssService: RssServiceProtocol {
    
    func searchFeed(url: URL, completionHandler: (_ error: String?, _ data: SearchFeed?) -> Void) {
        let searchFeed = SearchFeed.init(title: "Test Feed record", url: URL.init(string: "https://www.nasa.gov/rss/dyn/breaking_news.rss")!, categories: ["dd646"])
        completionHandler(nil, searchFeed)
    }
}
