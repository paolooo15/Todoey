//
//  Item.swift
//  Todoey
//
//  Created by Paolo Vasilev on 4/4/19.
//  Copyright © 2019 Paolo Vasilev. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
   @objc dynamic var title : String = ""
   @objc dynamic var done : Bool = false
    @objc dynamic var dataCreated: Date?
   var parentCategoty = LinkingObjects(fromType: Category.self, property: "items")
}
