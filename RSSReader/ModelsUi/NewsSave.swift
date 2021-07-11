//
//  NewsSave.swift
//  RSSReader
//
//  Created by swamnx on 11.07.21.
//

import Foundation
import UIKit

struct NewsSave {
    
    var url: String
    var title: String
    var text: String
    var icons =  [UIImage]()
    var categories = [String]()
    var read = false
    var favourite = false
    var deleted = false
}
