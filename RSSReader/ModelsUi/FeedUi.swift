//
//  FeedUi.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation
import UIKit

struct FeedUi {
    
    var id: Int
    var icon: UIImage?
    var title: String
    var url: URL
    var categories = [String]()
    var news = [NewsUi]()
    
    var totalNumberOfNews: Int {
        return news.count
    }
    
    func getCellText() -> String {
        var text = title
        for category in categories {
            text += " "
            text += category
        }
        return text + " " + String.init(totalNumberOfNews)
    }
}
