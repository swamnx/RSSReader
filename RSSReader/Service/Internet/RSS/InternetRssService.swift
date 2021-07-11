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
        URLSession(configuration: .default).dataTask(with: createdUrl) { data, _, error in
            if error != nil || data == nil {
                return completionHandler("Problem with receving data from entered URl", nil)
            }
            let xmlParser = SWXMLHash.lazy(data!)
            let channelOptional: Channel? = try? xmlParser["rss"]["channel"].value()
            guard let channel = channelOptional else {
                return completionHandler("Not Rss 2.0 Site", nil)
            }
            let chanelImage = InternetRssService.downloadImage(imageUrl: channel.imageUrl)
            let categories = InternetRssService.extractCategories(channel: channel)
            let news = InternetRssService.extractNews(channel: channel)
            let convertedResponse = SearchFeed.init(url: url,
                                                   title: channel.title,
                                                   categories: categories,
                                                   icon: chanelImage,
                                                   news: news)
            return completionHandler(nil, convertedResponse)
        }.resume()
    }
    
}

//
// MARK: Extractors
//
extension InternetRssService {
    
    private static func extractCategories(channel: Channel) -> [String] {
        return .init(Set<String>.init(channel.items.flatMap({item in return item.categories})))
    }
    
    private static func extractNews(channel: Channel) -> [SearchNews] {
        return channel.items.map({ item in
            return .init(url: item.link, title: item.title, text: item.description, categories: item.categories, icons: [])
        })
    }
    
    private static func downloadImage(imageUrl: String?) -> UIImage? {
        guard let url = imageUrl else { return nil }
        guard let downloadedImage = try? Data(contentsOf: URL.init(string: url)!) else { return nil }
        return .init(data: downloadedImage)
    }
}
//
// MARK: Mappers
//
extension InternetRssService {
    
    private struct Channel: XMLIndexerDeserializable {
        let title: String
        let description: String
        let items: [Item]
        let imageUrl: String?
        static func deserialize(_ node: XMLIndexer) throws -> Channel {
            return try Channel(title: node["title"].value(),
                             description: node["description"].value(),
                             items: node["item"].value(),
                             imageUrl: node["image"]["url"].value())
        }
    }
    
    private struct Item: XMLIndexerDeserializable {
        let title: String
        let link: String
        let description: String
        let imageUrl: String?
        let imageUrls: [String]
        let categories: [String]

        static func deserialize(_ node: XMLIndexer) throws -> Item {
            return try Item(title: node["title"].value(),
                           link: node["link"].value(),
                           description: node["description"].value(),
                           imageUrl: node["enclosure"].element?.attribute(by: "url")?.text,
                           imageUrls: deserializeImagesUrls(node),
                           categories: node["category"].value())
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
}
