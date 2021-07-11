//
//  NewsRealm.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import RealmSwift

class NewsRealm: Object {
    
    @Persisted var uuid: UUID
    @Persisted var url: String
    @Persisted var title: String
    @Persisted var text: String
    @Persisted var categories: List<String>
    @Persisted var imagesData: List<Data>
    
    @Persisted(originProperty: "news") var feed: LinkingObjects<FeedRealm>
    
    convenience init(url: String, title: String, text: String, categories: [String], images: [UIImage]) {
        self.init()
        self.url = url
        self.title = title
        self.text = text
        for image in images {
            imagesData.append(image.jpegData(compressionQuality: 1.0)!)
        }
        self.categories.append(objectsIn: categories)
    }
}
