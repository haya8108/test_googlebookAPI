////
////  GoogleBook.swift
////  MyLibrary
////
////  Created by haya on 2018/11/24.
////  Copyright © 2018年 haya. All rights reserved.
////

import Foundation
import UIKit

struct  GoogleBook: Codable {
     let items: [Items]?
}

struct Items: Codable {
    let volumeInfo: VolumeInfo?
}

struct VolumeInfo: Codable {
    let title: String?
    let authors: [String]?
    let industryIdentifiers: [[String : String]]?
    let imageLinks: [String : String]?
    let description: String?
    
}


enum GoogleBookEndpoint: Endpoint {
    case nameToIsbn(bookName: String)

    var baseUrl: String {
        return "https://www.googleapis.com"
    }

    var path: String {
        return "/books/v1/volumes"
    }

    var queryItems: [URLQueryItem] {
        var items = [URLQueryItem]()
        switch self {
        case .nameToIsbn(bookName: let bookName):
            let name = URLQueryItem(name: "q", value: bookName)
            let max = URLQueryItem(name: "maxResults", value: "40")
            items.append(name)
            items.append(max)
            return items
        }
    }
}



