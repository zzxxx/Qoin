//
//  QCategory.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import RealmSwift

class QCategory: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var isExpense = true
    @objc dynamic var title = ""
    @objc dynamic var image = ""
    @objc dynamic var order = 0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
