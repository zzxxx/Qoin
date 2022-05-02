//
//  QDBService.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import RealmSwift

class QDBService {
    
    //MARK: - Realm instane
    static var realm: Realm {
        get {
            do {
                let realm = try Realm()
                return realm
            } catch { print("Could not access database: ", error)  }
            return self.realm
        }
    }
    
    

//    //MARK: - Actions
    static func add(transaction: QTransaction, toAccount account: QAccount) {
        writeSimple {
            account.transactions.append(transaction)
            realm.add(account, update: .modified)
        }
    }
    
    static func update(_ transaction: QTransaction) {
        save(transaction)
    }
    
    static func getCountOfAccounts() -> Int {
        return realm.objects(QAccount.self).count
    }
    
    static func getAccounts() -> [QAccount] {
        return realm.objects(QAccount.self).sorted { $0.id > $1.id }
    }
    
    static func getCategories() -> [QCategory] {
        return Array(realm.objects(QCategory.self))
    }
    
    
    //MARK: - Util
    static func add(_ obj: [Object]?) {
        guard let obj = obj else {return}
        writeSimple {
            realm.add(obj)
        }
    }
    
    static func save(_ obj: [Object]?) {
        guard let obj = obj else {return}
        writeSimple {
            realm.add(obj, update: .modified)
        }
    }
    
    static func save(_ obj: Object?) {
        guard let obj = obj else {return}
        writeSimple {
            realm.add(obj, update: .modified)
        }
    }
    
    static func delete(_ obj: Object?) {
        guard let obj = obj else {return}
        writeSimple {
            realm.delete(obj)
        }
    }
    
    
    //MARK: - Support
    static func drop() {
        QDBService.needsReload = false
        
        writeSimple {
            realm.deleteAll()
        }
    }
    
    static func deleteAll(except types: Object.Type...) {
        writeSimple {
            realm.configuration.objectTypes?.filter{ type in types.contains{ $0 == type } == false}.forEach{ objectType in
                if let type = objectType as? Object.Type { realm.delete(realm.objects(type)) }
            }
        }
    }
    
    
    //MARK: - Write to base
    static func beginWrite() {
        realm.beginWrite()
    }
    
    static func commitWrite() {
        do { try realm.commitWrite() } catch { print(error.localizedDescription) }
    }
    
    static func cancelWrite() {
        realm.cancelWrite()
    }
    
    static func write( transaction: @escaping () -> ()) {
        DispatchQueue.global().async {
            autoreleasepool {
                do {
                    try Self.realm.write {
                        transaction()
                    }
                } catch { print("Could not access database: ", error) }
            }
        }
    }
    
    static func writeSimple( writeClosure: () -> ()) {
        do {
            try Self.realm.write {
                writeClosure()
            }
        } catch { print("Could not access database: ", error) }
    }
    
    
    //MARK: - ETC simple
    static func setNeedsReload() {
        needsReload = true
    }
    
    static var needsReload: Bool {
        get { return ud.bool(forKey: Key.kLoad)  }
        set { ud.setValue(newValue, forKey: Key.kLoad) }
    }
    
    static fileprivate var ud: UserDefaults {
        get { return UserDefaults.standard }
    }
}

fileprivate struct Key {
    static let kLoad = "kLoad"
}
