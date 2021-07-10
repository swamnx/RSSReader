//
//  FeedUi.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation
import UIKit

struct FeedUi {
    
    var id: UUID
    var url: String
    var title: String
    var categories = [String]()
    var icon: UIImage?
    var news = [NewsUi]()
    
    func getCellText() -> String {
        var text = title
        for category in categories {
            text += " "
            text += category
        }
        return text + " " + String.init(news.count)
    }
}
