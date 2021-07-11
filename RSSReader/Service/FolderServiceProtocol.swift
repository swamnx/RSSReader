//
//  FolderService.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

protocol FolderServiceProtocol {
    
    func loadAll() -> [FolderUi]
    func loadById(id: UUID) -> FolderUi?
    func removeById(id: UUID) -> Bool
    func save(folder: FolderSave) -> FolderUi?
    func removeFeed(folderId: UUID, feedId: UUID) -> FolderUi?
    func addFeed(folderId: UUID, feedId: UUID) -> FolderUi?
}
