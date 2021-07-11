//
//  FeedCreate.swift
//  RSSReader
//
//  Created by swamnx on 5.07.21.
//

import Foundation
import UIKit

struct FeedSave {
    
    var url: String
    var title: String
    var categories = [String]()
    var icon: UIImage?
    var news = [NewsSave]()
}
