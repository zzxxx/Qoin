//
//  QAccount.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import RealmSwift

class QAccount: Object {
    
    @objc dynamic var title = ""
    @objc dynamic var id = 0
    @objc dynamic var order = 0
    
    var transactions = List<QTransaction>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
