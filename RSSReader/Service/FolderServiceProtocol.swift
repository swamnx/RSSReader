//
//  FolderService.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

protocol FolderServiceProtocol {
    
    func loadAll() -> [FolderUi]
    func loadById(id: Int) -> FolderUi?
    func removeById(id: Int) -> Bool
    func save(folder: FolderSave) -> FolderUi?
    func saveAll(folders: [FolderSave]) -> [FolderUi]?
    func update(folder: FolderUi) -> FolderUi?
}
