//
//  DummyFolderService.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

class DummyFolderService: FolderServiceProtocol {
    
    var folders =  [FolderUi.init(id: 0, title: "Some empty folder")]
    
    func loadAll() -> [FolderUi] {
        return folders
    }
    
    func loadById(id: Int) -> FolderUi? {
        return folders.first(where: {$0.id == id})
    }
    
    func removeById(id: Int) -> Bool {
        let index = folders.firstIndex(where: {$0.id == id})
        guard let unwrappedIndex = index else { return false }
        folders.remove(at: unwrappedIndex)
        return true
    }
    
    func save(folder: FolderSave) -> FolderUi? {
        let id = Int.random(in: 1...99999)
        let newFolder = FolderUi.init(id: id, title: folder.title)
        folders.append(newFolder)
        return newFolder
    }
    
    func saveAll(folders: [FolderSave]) -> [FolderUi]? {
        var newFolders = [FolderUi]()
        for folder in folders {
            let id = Int.random(in: 1...99999)
            let newFolder = FolderUi.init(id: id, title: folder.title)
            newFolders.append(newFolder)
        }
        self.folders.append(contentsOf: newFolders)
        return newFolders
    }
    
    func update(folder: FolderUi) -> FolderUi? {
        let index = folders.firstIndex(where: {$0.id == folder.id})
        guard let unwrappedIndex = index else { return nil }
        folders[unwrappedIndex] = folder
        return folder
    }
    
}
