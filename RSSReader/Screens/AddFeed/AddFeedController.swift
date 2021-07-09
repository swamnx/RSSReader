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

    var params = AddFeedInitParams()
    var rssService = DummyRssService()
    
    var foundCategories = [String]()
    var rssFeedHasCategories = false
    var loadedByDefault = false
    
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
            searchField.text = params.existedFeed?.url.absoluteString
            foundCategories = params.existedFeed!.categories
            loadedByDefault = true
            categoriesView.reloadData()
        }
    }

}

//
// MARK: Table view data source
//
extension AddFeedController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foundCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellId", for: indexPath)
        cell.textLabel?.text = foundCategories[indexPath.row]
        return cell
    }

}

//
// MARK: Selection and Deselection actions
//
extension AddFeedController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !loadedByDefault && rssFeedHasCategories && tableView.indexPathsForSelectedRows != nil {
            self.enableSaveButton()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if !loadedByDefault && rssFeedHasCategories && tableView.indexPathsForSelectedRows == nil {
            self.disableSaveButton()
        }
    }
}

//
// MARK: Saving Action
//
extension AddFeedController {
    
    @IBAction func buttonTapped(_ sender: UIButton) {
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
                self?.rssFeedHasCategories = false
                self?.disableSaveButton()
                self?.foundCategories.removeAll()
                let alertController = UIAlertController(title: error!, message: nil, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil )
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
                return
            }
            loadedByDefault = false
            if response.categories.count > 0 {
                self?.rssFeedHasCategories = true
                self?.disableSaveButton()
            } else {
                self?.enableSaveButton()
            }
            self?.foundCategories = response.categories
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
