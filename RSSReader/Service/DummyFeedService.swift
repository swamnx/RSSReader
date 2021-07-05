//
//  DummyFeedService.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

class DummyFeedService: FeedServiceProtocol {
    
    var feeds = [FeedUi.init(id: 0, title: "First Feed", categories: []),
                 FeedUi.init(id: 1, icon: nil, title: "Second Feed", categories: ["dogs", "fishes"])]
    
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
        let newFeed = FeedUi.init(id: id, icon: feed.icon, title: feed.title, categories: feed.categories)
        feeds.append(newFeed)
        return newFeed
    }
    
    func saveAll(feeds: [FeedSave]) -> [FeedUi]? {
        var newFeeds = [FeedUi]()
        for feed in feeds {
            let id = Int.random(in: 1...99999)
            let newFeed = FeedUi.init(id: id, icon: feed.icon, title: feed.title, categories: feed.categories)
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
}
