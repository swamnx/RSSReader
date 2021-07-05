//
//  FeedService.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

protocol FeedServiceProtocol {
    
    func loadAll() -> [FeedUi]
    func loadById(id: Int) -> FeedUi?
    func removeById(id: Int) -> Bool
    func save(feed: FeedSave) -> FeedUi?
    func saveAll(feeds: [FeedSave]) -> [FeedUi]?
    func update(feed: FeedUi) -> FeedUi?
}
