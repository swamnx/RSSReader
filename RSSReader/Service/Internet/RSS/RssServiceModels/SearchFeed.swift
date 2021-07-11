//
//  SearchFeed.swift
//  RSSReader
//
//  Created by swamnx on 6.07.21.
//

import Foundation
import UIKit

struct SearchFeed {
    
    var url: String
    var title: String
    var categories: [String]
    var icon: UIImage?
    var news: [SearchNews]
}
