//
//  InternetRssService.swift
//  RSSReader
//
//  Created by swamnx on 11.07.21.
//

import Foundation
import SWXMLHash

class InternetRssService: RssServiceProtocol {
    
    func searchFeed(url: String, completionHandler: @escaping  (_ error: String?, _ data: SearchFeed?) -> Void) {
        guard let createdUrl = URL.init(string: url) else { return completionHandler("URL for searching can't be creaeted", nil) }
        URLSession(configuration: .default).dataTask(with: createdUrl) { [weak self] data, response, error in
            if error != nil || data == nil {
                return completionHandler("Problem with receving data from entered URl", nil)
            }
            let xmlParser = SWXMLHash.lazy(data!)
            let channel: Channel? = try? xmlParser["rss"]["channel"].value()
            if channel == nil {
                return completionHandler("Not Rss Site", nil)
            }
            let categories = self?.extractAvailableCategories(channel: channel!)
            let convertedResponse = SearchFeed.init(icon: nil,
                                                   title: channel!.title,
                                                   url: url,
                                                   categories: categories ?? [])
            return completionHandler(nil, convertedResponse)
        }.resume()
    }

    struct Channel: XMLIndexerDeserializable {
        let title: String
        let description: String
        let items: [Item]
        
        static func deserialize(_ node: XMLIndexer) throws-> Channel {
            return try Channel(
                title: node["title"].value(),
                description: node["description"].value(),
                items: node["item"].value()
            )
        }
    }
    
    struct Item: XMLIndexerDeserializable {
        let title: String
        let link: String
        let description: String
        let enclosure: String?
        let categories: [String]

        static func deserialize(_ node: XMLIndexer) throws -> Item {
            return try Item(
                title: node["title"].value(),
                link: node["link"].value(),
                description: node["description"].value(),
                enclosure: node["enclosure"].value(),
                categories: node["category"].value()
            )
        }
    }
    
    private func extractAvailableCategories(channel: Channel) -> [String] {
        var uniqueCategories = Set<String>()
        for item in channel.items {
            for category in item.categories {
                uniqueCategories.insert(category)
            }
        }
        return .init(uniqueCategories)
    }
}
