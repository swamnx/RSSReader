//
//  FeedRealm.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import RealmSwift

class FeedRealm: Object {
    
    @Persisted var uuid: UUID
    @Persisted var url: String
    @Persisted var title: String
    @Persisted var categories: List<String>
    @Persisted var imageData: Data?
    @Persisted var news: List<NewsRealm>
    
    @Persisted(originProperty: "feeds") var folder: LinkingObjects<FolderRealm>
    
    convenience init(title: String, url: String, categories: [String], image: UIImage?) {
        self.init()
        self.title = title
        self.url = url
        self.categories.append(objectsIn: categories)
        if image != nil {
            imageData = image!.jpegData(compressionQuality: 1.0)
        }
    }
}
