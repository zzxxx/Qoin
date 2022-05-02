//
//  QDashboardTableController.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import UIKit
import RealmSwift

protocol QDashboardPresenterProtocol {
    func numberOfSections() -> Int
    func numberOfItems(inSection section: Int) -> Int
    func sectionTitle(atIndex: Int) -> String?
    func fill(cell: UITableViewCell, at indexPath: IndexPath)
    func deleteItem(at indexPath: IndexPath)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    func willAppear()
    
    func addPressed()
}


final class QDashboardPresenter: QDashboardPresenterProtocol {
    
    private unowned let view: QDashboardViewProtocol
    private let router: RouterDashboardProtocol
    private lazy var stash: StashProtocol = {
        return QStash()
    }()
    
    private var accounts = [QAccount]()
    private lazy var sign: String = {
        return stash.getCurrencySign()
    }()
    
    
    init(view: QDashboardViewProtocol, router: RouterDashboardProtocol) {
        self.view = view
        self.router = router
        accounts = stash.getAccounts()
    }
    
    
    //MARK: - Actions
    func willAppear() {
        accounts = stash.getAccounts()
    }
    
    func addPressed() {
        router.openNewTransactionScreen()
    }
    
    func numberOfSections() -> Int {
        return accounts.count
    }
    
    func numberOfItems(inSection section: Int) -> Int {
        return accounts[section].transactions.count
    }
    
    func sectionTitle(atIndex: Int) -> String? {
        let sumCount = accounts[atIndex].transactions.reduce(0) { $0 + ($1.isExpense ? -$1.ammount : $1.ammount) }
        return accounts[atIndex].title + Key.accountBalance + String(format: "%.0f", sumCount) + sign
    }
    
    func fill(cell: UITableViewCell, at indexPath: IndexPath) {
        let transaction = accounts[indexPath.section].transactions[indexPath.row]
        
        let transactionAmmount = transaction.isExpense ? "-" : ""
        cell.textLabel?.text = String(format: (transactionAmmount + "%.0f%@"), transaction.ammount, sign)
        
        cell.detailTextLabel?.text = transaction.categories.first?.title
        cell.textLabel?.textColor = (transaction.isExpense) ? .red : .green
    }
    
    func deleteItem(at indexPath: IndexPath) {
        let transaction = accounts[indexPath.section].transactions[indexPath.row]
        stash.removeTransaction(aTransaction: transaction)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteItem(at: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         view.tintColor = .darkGray

        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}


//MARK: - Tools
fileprivate struct Key {
    static let filterCell = "FilterTableViewCell"
    static let filterPreloadCell = "FilterTableViewCell"
    
    static let accountBalance = " balance: "
}
