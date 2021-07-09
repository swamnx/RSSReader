//
//  DummyFeedService.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

class DummyFeedService: FeedServiceProtocol {
    
    var feeds = [
        FeedUi.init(id: 0, title: "First Feed", url: URL.init(string: "https://www.nasa.gov/rss/dyn/breaking_news.rss")!, categories: []),
        FeedUi.init(id: 1, icon: .add, title: "Second Feed", url: URL.init(string: "https://www.nasa.gov/rss/dyn/breaking_news.rss")!, categories: ["dogs", "fishes"]),
        FeedUi.init(id: 2, icon: .checkmark, title: "Feed in Folder", url: URL.init(string: "https://www.nasa.gov/rss/dyn/breaking_news.rss")!, categories: ["pets", "cars"])
    ]
    
    static var shared = DummyFeedService()
    
    private init() {
        
    }
    
    func loadAll() -> [FeedUi] {
        return feeds
    }
    
    func loadById(id: Int) -> FeedUi? {
        return feeds.first(where: {$0.id == id})
    }
    
    func removeById(id: Int) -> Bool {
        let index = feeds.firstIndex(where: {$0.id == id})
        guard let unwrappedIndex = index else { return false }
        feeds.remove(at: unwrappedIndex)
        return true
    }
    
    func save(feed: FeedSave) -> FeedUi? {
        let id = Int.random(in: 1...99999)
        let newFeed = FeedUi.init(id: id, icon: feed.icon, title: feed.title, url: feed.url, categories: feed.categories)
        feeds.append(newFeed)
        return newFeed
    }
    
    func saveAll(feeds: [FeedSave]) -> [FeedUi]? {
        var newFeeds = [FeedUi]()
        for feed in feeds {
            let id = Int.random(in: 1...99999)
            let newFeed = FeedUi.init(id: id, icon: feed.icon, title: feed.title, url: feed.url, categories: feed.categories)
            newFeeds.append(newFeed)
        }
        self.feeds.append(contentsOf: newFeeds)
        return newFeeds
    }
    
    func update(feed: FeedUi) -> FeedUi? {
        let index = feeds.firstIndex(where: {$0.id == feed.id})
        guard let unwrappedIndex = index else { return nil }
        feeds[unwrappedIndex] = feed
        return feed
    }
    
    func loadAllWithoutFolders() -> [FeedUi] {
        let feedsInFolders = DummyFolderService.shared.loadAll().flatMap({return $0.feeds })
        let allFeeds = loadAll()
        let feedsNotInFolders = allFeeds.filter({ feed in
            return !feedsInFolders.contains(where: {$0.id == feed.id})
        })
        return feedsNotInFolders
    }
}
