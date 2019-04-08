//
//  Data.swift
//  Todoey
//
//  Created by Paolo Vasilev on 4/4/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import Foundation
import RealmSwift

class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
    
}
