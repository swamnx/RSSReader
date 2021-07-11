//
//  Converters.swift
//  RSSReader
//
//  Created by swamnx on 10.07.21.
//

import Foundation
import RealmSwift
import UIKit
 
class Converters {
    
    static var shared = Converters()
    
    private init() {
        
    }
    
    func convertFolderRealmToFolderUi(source: FolderRealm?) -> FolderUi? {
        guard let folderRealm = source else { return nil }
        var convertedFeeds = [FeedUi]()
        for realmFeed in folderRealm.feeds {
            if let convertedFeed = convertFeedRealmToFeedUi(source: realmFeed) {
                convertedFeeds.append(convertedFeed)
            }
        }
        return FolderUi.init(id: folderRealm.uuid,
                            title: folderRealm.title,
                            feeds: convertedFeeds)
    }
    
    func convertFeedRealmToFeedUi(source: FeedRealm?) -> FeedUi? {
        guard let feedRealm = source else { return nil }
        var convertedNewsCollection = [NewsUi]()
        for realmNews in feedRealm.news {
            if let convertedNews = convertNewsRealmToNewsUi(source: realmNews) {
                convertedNewsCollection.append(convertedNews)
            }
        }
        var convertedImage: UIImage?
        if let dataImage = source?.imageData {
            convertedImage = UIImage.init(data: dataImage)!
        }
        var convertedCategories = [String]()
        for category in feedRealm.categories {
            convertedCategories.append(category)
        }
        return FeedUi.init(id: feedRealm.uuid,
                           url: feedRealm.url,
                           title: feedRealm.title,
                           categories: convertedCategories,
                           icon: convertedImage,
                           news: convertedNewsCollection)
    }
    
    func convertNewsRealmToNewsUi(source: NewsRealm?) -> NewsUi? {
        guard let newsRealm = source else { return nil }
        var convertedImages = [UIImage]()
        for dataImage in newsRealm.imagesData {
            convertedImages.append(.init(data: dataImage)!)
        }
        return NewsUi.init(id: newsRealm.uuid,
                          url: newsRealm.url,
                          title: newsRealm.title,
                          text: newsRealm.text,
                          icons: convertedImages)
    }
}
