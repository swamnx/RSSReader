//
//  RssServiceProtocol.swift
//  RSSReader
//
//  Created by swamnx on 6.07.21.
//

import Foundation

protocol RssServiceProtocol {
    
    func searchFeed(url: String, completionHandler: @escaping (_ error: String?, _ data: SearchFeed?) -> Void)
}
