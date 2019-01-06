//
//  Structs.swift
//  MyLibrary
//
//  Created by haya on 2018/11/19.
//  Copyright © 2018年 haya. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case someError(String)
}

struct Library {
    let formal: String?


    init(json: [String : Any]) throws {
        
        guard let formal = json["formal"] as? String else { throw SerializationError.someError("some error occur")}
        
        self.formal = formal
    }
    
}

