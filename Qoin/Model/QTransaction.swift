//
//  QTransaction.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import RealmSwift

class QTransaction: Object {
    
    @objc dynamic var date = Date()
    @objc dynamic var ammount: Double = 0
    @objc dynamic var isExpense = true
    @objc dynamic var note = ""
    
    var categories = List<QCategory>()
    
}
