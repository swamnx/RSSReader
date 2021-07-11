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
            let categories = InternetRssService.extractCategories(channel: channel!)
            var chanelImage: UIImage?
            if channel?.imageUrl != nil {
                if let downloadedChanelImageData = try? Data(contentsOf: URL.init(string: (channel?.imageUrl)!)!) {
                    chanelImage = .init(data: downloadedChanelImageData)!
                }
            }
            let news = InternetRssService.extractNews(channel: channel!)
            let convertedResponse = SearchFeed.init(icon: chanelImage,
                                                   title: channel!.title,
                                                   url: url,
                                                   categories: categories,
                                                   news: news)
            return completionHandler(nil, convertedResponse)
        }.resume()
    }

    struct Channel: XMLIndexerDeserializable {
        let title: String
        let description: String
        let items: [Item]
        let imageUrl: String?
        static func deserialize(_ node: XMLIndexer) throws-> Channel {
            return try Channel(
                title: node["title"].value(),
                description: node["description"].value(),
                items: node["item"].value(),
                imageUrl: node["image"]["url"].value()
            )
        }
    }
    
    struct Item: XMLIndexerDeserializable {
        let title: String
        let link: String
        let description: String
        let imageUrl: String?
        let imageUrls: [String]
        let categories: [String]

        static func deserialize(_ node: XMLIndexer) throws -> Item {
            return try Item(
                title: node["title"].value(),
                link: node["link"].value(),
                description: node["description"].value(),
                imageUrl: node["enclosure"].element?.attribute(by: "url")?.text,
                imageUrls: deserializeImagesUrls(node),
                categories: node["category"].value()
            )
        }
        
        private static func deserializeImagesUrls(_ node: XMLIndexer) -> [String] {
            var extractedImageUrls = [String]()
            for mediaContent in node["media:content"].all {
                if let url = mediaContent.element?.attribute(by: "url")?.text {
                    extractedImageUrls.append(url)
                }
            }
            return extractedImageUrls
        }
    }
    
    private static func extractCategories(channel: Channel) -> [String] {
        var uniqueCategories = Set<String>()
        for item in channel.items {
            for category in item.categories {
                uniqueCategories.insert(category)
            }
        }
        return .init(uniqueCategories)
    }
    
    private static func extractNews(channel: Channel) -> [SearchNews] {
        return channel.items.map({ item in
                                    return .init(url: item.link,
                                                title: item.title,
                                                text: item.description,
                                                imagesData: [],
                                                date: nil,
                                                categories: item.categories)
        })
    }
}
