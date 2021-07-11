//
//  FeedService.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

protocol FeedServiceProtocol {
    
    func loadAll() -> [FeedUi]
    func loadAllWithoutFolders() -> [FeedUi]
    func loadById(id: UUID) -> FeedUi?
    func removeById(id: UUID) -> Bool
    func save(feed: FeedSave) -> FeedUi?
    func updateWith(feed: FeedSave, id: UUID) -> FeedUi?
}
