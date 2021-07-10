//
//  FolderRealm.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import RealmSwift

class FolderRealm: Object {
    
    @Persisted var uuid: UUID
    @Persisted var title: String
    @Persisted var feeds: List<FeedRealm>
    
    convenience init(title: String) {
        self.init()
        self.title = title
    }
    
    convenience init(uuid: UUID) {
        self.init()
        self.uuid = uuid
    }
}
