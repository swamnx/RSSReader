//
//  AddFeedController.swift
//  RSSReader
//
//  Created by swamnx on 6.07.21.
//

import Foundation
import UIKit

class AddFeedController: UIViewController, UITextFieldDelegate {
    
    class AddFeedInitParams {
        var add = false
        var existedFeed: FeedUi?
    }
    
    class ResponseAttributes {
        var categories = [String]()
        var icon: UIImage?
        var title: String?
        var url: URL?
        var rssFeedHasCategories = false
        var loadedByDefault = false
    }
    
    var rssService = DummyRssService()
    var feedService = DummyFeedService.shared

    var params = AddFeedInitParams()
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
            if (params.existedFeed?.categories.count)! > 0 {
                response.categories = params.existedFeed!.categories
            }
            searchField.text = params.existedFeed?.url.absoluteString
            categoriesView.reloadData()
        }
    }

}

//
// MARK: Table view data source
//
extension AddFeedController: UITableViewDelegate, UITableViewDataSource {
    
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
extension AddFeedController {
    
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
extension AddFeedController {
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var selectedCategories = [String]()
        if categoriesView.indexPathsForSelectedRows != nil {
            for indexPath in categoriesView.indexPathsForSelectedRows! {
                selectedCategories.append(response.categories[indexPath.row])
            }
        }
        if params.add {
            let feedSave = FeedSave.init(icon: response.icon, title: response.title!, url: response.url!, categories: selectedCategories)
            feedService.save(feed: feedSave)
        } else {
            params.existedFeed!.title = response.title!
            params.existedFeed!.icon = response.icon
            params.existedFeed!.categories = selectedCategories
            params.existedFeed!.url = response.url!
            feedService.update(feed: params.existedFeed!)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

//
// MARK: Search Action
//
extension AddFeedController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.isEmpty {
            return false
        }
        let url = URL.init(string: textField.text!)
        guard let unwrappedUrl = url else {return false}
        textField.resignFirstResponder()
        rssService.searchFeed(url: unwrappedUrl, completionHandler: { [weak self] error, searchFeedResponse in
            guard let response = searchFeedResponse else {
                self?.response.rssFeedHasCategories = false
                self?.disableSaveButton()
                self?.response.categories.removeAll()
                self?.response.icon = nil
                self?.response.title = nil
                self?.response.loadedByDefault = false
                let alertController = UIAlertController(title: error!, message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil )
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
                return
            }
            self?.response.loadedByDefault = false
            if response.categories.count > 0 {
                self?.response.rssFeedHasCategories = true
                self?.disableSaveButton()
            } else {
                self?.enableSaveButton()
            }
            self?.response.categories = response.categories
            self?.response.icon = response.icon
            self?.response.title = response.title
            self?.response.url = response.url
            self?.categoriesView.reloadData()
        })
       return true
    }
}

//
// MARK: Utility Methods
//

extension AddFeedController {
    
    private func disableSaveButton() {
        button.isEnabled = false
        button.backgroundColor = .gray
    }
    
    private func enableSaveButton() {
        button.isEnabled = true
        button.backgroundColor = .systemBlue
    }
}
