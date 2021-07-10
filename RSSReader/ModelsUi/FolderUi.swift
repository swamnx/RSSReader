//
//  FolderUi.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation

struct FolderUi {
    
    var id: Int
    var title: String
    var feeds = [FeedUi]()
    
    mutating func addFeed(feed: FeedUi) -> FolderUi {
        feeds.append(feed)
        return self
    }
    
    mutating func removeFeedAt(index: Int) -> Bool {
        feeds.remove(at: index)
        return true
    }
}
