//
//  AddOrEditFeedController.swift
//  RSSReader
//
//  Created by swamnx on 6.07.21.
//

import Foundation
import UIKit

class AddOrEditFeedController: UIViewController, UITextFieldDelegate {
    
    class AddOrEditFeedInitParams {
        var add = false
        var existedFeed: FeedUi?
    }
    
    class ResponseAttributes {
        var news = [SearchNews]()
        var categories = [String]()
        var icon: UIImage?
        var title: String?
        var url: String?
        var rssFeedHasCategories = false
        var loadedByDefault = false
    }
    
    var rssService = InternetRssService()
    var feedService = RealmFeedService.shared!

    var params = AddOrEditFeedInitParams()
    var response = ResponseAttributes()
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var categoriesView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchField.delegate = self
        categoriesView.delegate = self
        categoriesView.dataSource = self
        disableSaveButton()
        let screenTitleText = params.add ? "Add" : "Edit"
        self.title = screenTitleText
        button.setTitle("Save", for: .normal)
        if !params.add {
            response.icon = params.existedFeed?.icon
            response.title = params.existedFeed?.title
            response.url = params.existedFeed?.url
            response.loadedByDefault = true
            if params.existedFeed != nil {
                response.categories = params.existedFeed!.categories
            }
            searchField.text = params.existedFeed?.url
            categoriesView.reloadData()
        }
    }

}

//
// MARK: Table view data source
//
extension AddOrEditFeedController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return response.categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellId", for: indexPath)
        cell.textLabel?.text = response.categories[indexPath.row]
        return cell
    }

}

//
// MARK: Selection and Deselection actions
//
extension AddOrEditFeedController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !response.loadedByDefault && response.rssFeedHasCategories && tableView.indexPathsForSelectedRows != nil {
            self.enableSaveButton()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if  !response.loadedByDefault && response.rssFeedHasCategories && tableView.indexPathsForSelectedRows == nil {
            self.disableSaveButton()
        }
    }
}

//
// MARK: Saving Action
//
extension AddOrEditFeedController {
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        let selectedCategories = extractSelectedCategories()
        var filteredNews = response.news
        if response.rssFeedHasCategories {
            filteredNews = filterOnlySelectedCategories(news: filteredNews, categories: selectedCategories)
        }
        let newsSaveCollection = filteredNews.map({NewsSave.init(url: $0.url,
                                                      title: $0.title,
                                                      text: $0.text,
                                                      categories: $0.categories)
        })
        let feedSave = FeedSave.init(url: response.url!,
                                    title: response.title!,
                                    categories: selectedCategories,
                                    icon: response.icon,
                                    news: newsSaveCollection)
        let response: FeedUi?
        if params.add {
            response = feedService.save(feed: feedSave)
        } else {
            response = feedService.updateWith(feed: feedSave, id: params.existedFeed!.id)
        }
        if response != nil {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.present(AddOrEditFeedController.getOkAletControllerWith(title: "Can't saved Feed info"), animated: true, completion: nil)
        }
    }
}

//
// MARK: Search Action
//
extension AddOrEditFeedController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }
        textField.resignFirstResponder()
        rssService.searchFeed(url: textField.text!, completionHandler: { [weak self] error, searchFeedResponse in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard let response = searchFeedResponse else {
                    self.present(AddOrEditFeedController.getOkAletControllerWith(title: error!), animated: true, completion: nil)
                    return
                }
                self.response.loadedByDefault = false
                if response.categories.count > 0 {
                    self.response.rssFeedHasCategories = true
                    self.disableSaveButton()
                } else {
                    self.response.rssFeedHasCategories = false
                    self.enableSaveButton()
                }
                self.response.news = response.news
                self.response.categories = response.categories
                self.response.icon = response.icon
                self.response.title = response.title
                self.response.url = response.url
                self.categoriesView.reloadData()
            }
        })
       return true
    }
}

//
// MARK: Utility Methods
//
extension AddOrEditFeedController {
    
    private func disableSaveButton() {
        button.isEnabled = false
        button.backgroundColor = .gray
    }
    
    private func enableSaveButton() {
        button.isEnabled = true
        button.backgroundColor = .systemBlue
    }
    
    private func filterOnlySelectedCategories(news: [SearchNews], categories: [String]) -> [SearchNews] {
        var filteredNews = [SearchNews]()
        for newsItem in news {
            if newsItem.categories.contains(where: categories.contains) {
                filteredNews.append(newsItem)
            }
        }
        return filteredNews
    }
    
    private func extractSelectedCategories() -> [String] {
        var selectedCategories = [String]()
        if categoriesView.indexPathsForSelectedRows != nil {
            for indexPath in categoriesView.indexPathsForSelectedRows! {
                selectedCategories.append(response.categories[indexPath.row])
            }
        }
        return selectedCategories
    }
}

//
// MARK: Private Custom UI Controllers
//
extension AddOrEditFeedController {
    
    private static func getOkAletControllerWith(title: String) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil )
        alertController.addAction(okAction)
        return alertController
    }
}
