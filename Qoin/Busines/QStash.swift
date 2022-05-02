//
//  QStash.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation

protocol StashProtocol {
    func getCurrencySign() -> String
    func getAccountsNumber() -> Int
    func getAccounts() -> [QAccount]
    func getCategories() -> [QCategory]
    func getTransaction(atIndexPath indexPath: IndexPath) -> QTransaction?
    func addTransaction(isExpense: Bool, ammount: Double, account: QAccount, category: QCategory, date: Date)
    func removeTransaction(aTransaction: QTransaction)
}

class QStash: StashProtocol {
    
    func getCurrencySign() -> String {
        return Locale.current.currencySymbol ?? ""
    }
    
    func getAccountsNumber() -> Int {
        return QDBService.getCountOfAccounts()
    }
    
    func getAccounts() -> [QAccount] {
        return QDBService.getAccounts()
    }
    
    func getCategories() -> [QCategory] {
        return QDBService.getCategories()
    }
    
    func getTransaction(atIndexPath indexPath: IndexPath) -> QTransaction? {
        return QTransaction()
    }
    
    func addTransaction(isExpense: Bool, ammount: Double, account: QAccount, category: QCategory, date: Date) {
        
        let transaction = QTransaction()
        transaction.isExpense = isExpense
        transaction.ammount = ammount
        transaction.categories.append(category)
        transaction.date = date
        
        
        QDBService.add(transaction: transaction, toAccount: account)
    }
    
    func removeTransaction(aTransaction: QTransaction) {
        QDBService.delete(aTransaction)
    }
    
}
