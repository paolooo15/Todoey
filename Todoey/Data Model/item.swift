//
//  item.swift
//  Todoey
//
//  Created by Paolo Vasilev on 2/27/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import Foundation

class Item: Codable {
    //confoming to protocols to encodable , A type that can encode itself to an external representation. , such as JSON or Plist , using Codable for both encodable and decodable 
    var title : String = ""
    var done : Bool = false 
}
