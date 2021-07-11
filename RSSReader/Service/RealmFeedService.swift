//
//  RealmFeedService.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import UIKit
import RealmSwift

class RealmFeedService {
    
    static var shared = RealmFeedService()
    
    private var localRealm: Realm
    
    private init?() {
        do {
            try localRealm = Realm()
        } catch {
            precondition(true, "Failed due to Realm db problems")
            return nil
        }
    }
    
    func loadAll() -> [FeedUi] {
        let realmFeeds = localRealm.objects(FeedRealm.self)
        var convertedFeeds = [FeedUi]()
        for realmFeed in realmFeeds {
            if let convertedFeed = Converters.shared.convertFeedRealmToFeedUi(source: realmFeed) {
                convertedFeeds.append(convertedFeed)
            }
        }
        return convertedFeeds
    }
    
    func loadAllWithoutFolders() -> [FeedUi] {
        let realmFeeds = localRealm.objects(FeedRealm.self).filter({feedRealm in return feedRealm.folder.first == nil})
        var convertedFeeds = [FeedUi]()
        for realmFeed in realmFeeds {
            if let convertedFeed = Converters.shared.convertFeedRealmToFeedUi(source: realmFeed) {
                convertedFeeds.append(convertedFeed)
            }
        }
        return convertedFeeds
    }
    
    func loadById(id: UUID) -> FeedUi? {
        guard let realmFeed =  localRealm.objects(FeedRealm.self).filter("uuid = %@", id).first else { return nil }
        return Converters.shared.convertFeedRealmToFeedUi(source: realmFeed)
    }
    
    func removeById(id: UUID) -> Bool {
        guard let realmFeed =  localRealm.objects(FeedRealm.self).filter("uuid = %@", id).first else { return false }
        try? localRealm.write {
            localRealm.delete(realmFeed.news)
            localRealm.delete(realmFeed)
        }
        return true
    }
    
    func save(feed: FeedSave) -> FeedUi? {
        var realmNews = List<NewsRealm>()
        for newsItem in feed.news {
            realmNews.append(.init(url: newsItem.url, title: newsItem.title, text: newsItem.text, categories: newsItem.categories, images: []))
        }
        
        let realmFeed = FeedRealm.init(title: feed.title, url: feed.url, categories: feed.categories, image: feed.icon)
        realmFeed.news = realmNews
        try? localRealm.write {
           localRealm.add(realmFeed)
        }
        return Converters.shared.convertFeedRealmToFeedUi(source: realmFeed)
    }
    // No news Update
    func updateWith(feed: FeedSave, id: UUID) -> FeedUi? {
        guard let realmFeed =  localRealm.objects(FeedRealm.self).filter("uuid = %@", id).first else { return nil }
        try? localRealm.write {
            realmFeed.url = feed.url
            realmFeed.title = feed.title
            if feed.icon != nil {
                realmFeed.imageData = feed.icon!.jpegData(compressionQuality: 1.0)
            }
            realmFeed.categories.removeAll()
            realmFeed.categories.append(objectsIn: feed.categories)
        }
        return Converters.shared.convertFeedRealmToFeedUi(source: realmFeed)
    }
    
}
