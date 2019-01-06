//
//  BookSearchTableVC.swift
//  MyLibrary
//
//  Created by haya on 2018/11/24.
//  Copyright © 2018年 haya. All rights reserved.
//

import Foundation
import UIKit

class BookSearchTableVC: UITableViewController, UISearchBarDelegate {
    
    var resultBooks = [Items]()
   let cellId = "cellId"
    
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter book name"
        sb.barTintColor = .gray
        sb.delegate = self
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        
        if let navBar = navigationController?.navigationBar {
        
            navBar.isTranslucent = false
            navBar.barTintColor = .orange
        
            navBar.addSubview(searchBar)
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            searchBar.topAnchor.constraint(equalTo: navBar.topAnchor).isActive = true
            searchBar.leftAnchor.constraint(equalTo: navBar.leftAnchor, constant: 8).isActive = true
            searchBar.rightAnchor.constraint(equalTo: navBar.rightAnchor, constant: -8).isActive = true
            searchBar.bottomAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
        
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resultBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let book = resultBooks[indexPath.row].volumeInfo
        
        let cell = UITableViewCell(style: .subtitle , reuseIdentifier: cellId)
        cell.textLabel?.text = book?.title ?? ""
        cell.detailTextLabel?.text = book?.authors?[0] ?? ""
        
        if let thumbnail = book?.imageLinks!["thumbnail"],
            let url = URL(string: thumbnail.replacingOccurrences(of: "http://", with: "https://")),
            let imageData = try? Data(contentsOf: url),
            let image = UIImage(data: imageData) {
            cell.imageView?.image = image
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let book = self.resultBooks[indexPath.row].volumeInfo
        let bookDetailController = BookDetailController()
        bookDetailController.book = book
        searchBar.isHidden = true
        navigationController?.pushViewController(bookDetailController, animated: true)
    }
 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
  
        guard let key = searchBar.text else { return }
        NameToIsbn(searchKey: key) { (result) in
            self.resultBooks = result
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    
    func NameToIsbn(searchKey: String, completion: @escaping([Items]) -> Void) {
  
        let url = GoogleBookEndpoint.nameToIsbn(bookName: searchKey).request
        
      //  let strUrl = URLRequest(url: URL(string: "https://www.googleapis.com/books/v1/volumes?q=swift")!)

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            var googleBook: [Items] = []
            
            let decoder = JSONDecoder()
            
            do {
                let decoded = try decoder.decode(GoogleBook.self, from: data!)
    
                guard let items = decoded.items else { return }
                
                for item in items {
                    googleBook.append(item)
                }
            
                DispatchQueue.main.async(execute: {
                    () -> Void in completion(googleBook)
                })
            } catch { print("some error occur")
                
            }
        }
        task.resume()
    }
    
}
