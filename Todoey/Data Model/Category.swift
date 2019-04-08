//
//  Category.swift
//  Todoey
//
//  Created by Paolo Vasilev on 4/4/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
