//
//  BookDetailController.swift
//  MyLibrary
//
//  Created by haya on 2018/11/24.
//  Copyright © 2018年 haya. All rights reserved.
//

import Foundation
import UIKit

class BookDetailController: UITableViewController {
    
    var book: VolumeInfo?
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = UITableViewCell(style: .subtitle , reuseIdentifier: cellId)
        cell.textLabel?.text = book?.title ?? ""
        cell.detailTextLabel?.text = book?.authors?.joined(separator: " ") ?? ""
        
        if let thumbnail = book?.imageLinks!["thumbnail"],
            let url = URL(string: thumbnail.replacingOccurrences(of: "http://", with: "https://")),
            let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        }
        
        return cell
    }
    
}
