//
//  RealmFolfderService.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import UIKit
import RealmSwift

class RealmFolderService: FolderServiceProtocol {
    
    static var shared = RealmFolderService()
    
    private var localRealm: Realm
    
    private init?() {
        do {
            try localRealm = Realm()
        } catch {
            precondition(true, "Failed due to Realm db problems")
            return nil
        }
    }
    
    func loadAll() -> [FolderUi] {
        let realmFolders = localRealm.objects(FolderRealm.self)
        var convertedFolders = [FolderUi]()
        for realmFolder in realmFolders {
            if let convertedFolder = Converters.shared.convertFolderRealmToFolderUi(source: realmFolder) {
                convertedFolders.append(convertedFolder)
            }
        }
        return convertedFolders
    }
    
    func loadById(id: UUID) -> FolderUi? {
        guard let realmFolder =  localRealm.objects(FolderRealm.self).filter("uuid = %@", id).first else { return nil }
        return Converters.shared.convertFolderRealmToFolderUi(source: realmFolder)
    }
    
    func removeById(id: UUID) -> Bool {
        guard let realmFolder = localRealm.objects(FolderRealm.self).filter("uuid = %@", id).first else { return false }
        try? localRealm.write {
            for feed in realmFolder.feeds {
                for newsItem in feed.news {
                    localRealm.delete(newsItem)
                }
                localRealm.delete(feed)
            }
            localRealm.delete(realmFolder)
        }
        return true
    }
    
    func save(folder: FolderSave) -> FolderUi? {
        let realmFolder = FolderRealm.init(title: folder.title)
        try? localRealm.write {
           localRealm.add(realmFolder)
        }
        return Converters.shared.convertFolderRealmToFolderUi(source: realmFolder)
    }
    
    func removeFeed(folderId: UUID, feedId: UUID) -> FolderUi? {
        guard let realmFolder = localRealm.objects(FolderRealm.self).filter("uuid = %@", folderId).first else { return nil }
        guard let feedIndex = realmFolder.feeds.firstIndex(where: {$0.uuid == feedId}) else { return nil }
        try? localRealm.write {
            realmFolder.feeds.remove(at: feedIndex)
        }
        return Converters.shared.convertFolderRealmToFolderUi(source: realmFolder)
        
    }
    
    func addFeed(folderId: UUID, feedId: UUID) -> FolderUi? {
        guard let realmFolder = localRealm.objects(FolderRealm.self).filter("uuid = %@", folderId).first else { return nil }
        guard let realmFeed = localRealm.objects(FeedRealm.self).filter("uuid = %@", feedId).first else { return nil }
        try? localRealm.write {
            realmFolder.feeds.append(realmFeed)
        }
        return Converters.shared.convertFolderRealmToFolderUi(source: realmFolder)
    }
    
}
