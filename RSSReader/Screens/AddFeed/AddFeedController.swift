//
//  AddFeedController.swift
//  RSSReader
//
//  Created by swamnx on 6.07.21.
//

import Foundation
import UIKit

class AddFeedController: UIViewController {
    
    class AddFeedInitParams {
        var add = false
        var existedFeed: FeedUi?
    }

    var params = AddFeedInitParams()
    
    @IBOutlet weak var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if params.add {
            self.title = "Add"
            button.setTitle("Add", for: .normal)
        } else {
            self.title = "Edit"
            button.setTitle("Edit", for: .normal)
        }
        
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
