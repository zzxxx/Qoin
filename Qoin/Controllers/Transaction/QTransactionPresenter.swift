//
//  QTransactionPresenter.swift
//  Qoin
//
//  Created by Maksym S. on 29.04.2022.
//

import Foundation
import UIKit

protocol QTransactionPresenterProtocol {
    func screenLoaded()
    
    func numberOfSections() -> Int
    func numberOfRows(inSection: Int) -> Int
    func fill(cell: UITableViewCell, atIndexPath: IndexPath)
    func fill(ammountCell cell: QTransactionAmmountCellProtocol)
    func sectionTitle(atIndex: Int) -> String?
    func cellPressed(atIndexPath: IndexPath)
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath?
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    
    func addPressed(_ tableView: UITableView)
}


final class QTransactionPresenter: NSObject, QTransactionPresenterProtocol {
   
    private unowned let view: QTransactionViewProtocol
    private let router: RouterTransactionProtocol
    private lazy var stash: StashProtocol = {
        return QStash()
    }()
    
    private var isExpense = true
    private var ammount = ""
    private var account = 0
    private var category = 0
    
    private var accounts = [QAccount]()
    private var catExpense = [QCategory]()
    private var catIncome = [QCategory]()
    
    private var doNeedActivateAmmount = true
    
    
    init(view: QTransactionViewProtocol, router: RouterTransactionProtocol) {
        self.view = view
        self.router = router
    }
    
    func screenLoaded() {
        accounts = stash.getAccounts()
        
        let categories = stash.getCategories()
        catExpense.append(contentsOf: categories.filter({ $0.isExpense }))
        catIncome.append(contentsOf: categories.filter({ $0.isExpense == false }))
    }
    
    
    //MARK: - Protocol
    func numberOfSections() -> Int {
        return TransactionCellFunctionality.allCases.count
    }
    
    func numberOfRows(inSection: Int) -> Int {
        switch TransactionCellFunctionality(rawValue: inSection) {
        case .isExpense:
            return 2
        case .ammount:
            return 1
        case .account:
            return accounts.count
        case .category:
            return isExpense ? catExpense.count : catIncome.count
        default:
            return 0
        }
    }
    
        
    func fill(cell: UITableViewCell, atIndexPath: IndexPath) {
        switch TransactionCellFunctionality(rawValue: atIndexPath.section) {
        case .isExpense:
            cell.textLabel?.text = (atIndexPath.row == 0) ? "Expense" : "Income"
            cell.isSelected = (atIndexPath.row == 0 && isExpense) ? true : false
        case .ammount: break
        case .account:
            cell.textLabel?.text = accounts[atIndexPath.row].title
            cell.isSelected = atIndexPath.row == account
        case .category:
            cell.textLabel?.text = isExpense ? catExpense[atIndexPath.row].title : catIncome[atIndexPath.row].title
            cell.isSelected = atIndexPath.row == category
        default:
            break
        }
    }
    
    func fill(ammountCell cell: QTransactionAmmountCellProtocol) {
        cell.textField.delegate = self
        cell.textField.placeholder = Key.textPlaceholder
        if doNeedActivateAmmount && cell.textField.canBecomeFirstResponder {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                cell.textField.becomeFirstResponder()
            }
            doNeedActivateAmmount = false
        }
    }
    
    func sectionTitle(atIndex: Int) -> String? {
        return TransactionCellFunctionality(rawValue: atIndex)?.text
    }
    
    func cellPressed(atIndexPath: IndexPath) {
        
    }
    
    func addPressed(_ tableView: UITableView) {
        let selectedRows = tableView.indexPathsForSelectedRows
        
        guard
            let aIsExpense = selectedRows?.filter({ $0.section == TransactionCellFunctionality.isExpense.rawValue }).first,
            let aAccount = selectedRows?.filter({ $0.section == TransactionCellFunctionality.account.rawValue }).first,
            let aCategory = selectedRows?.filter({ $0.section == TransactionCellFunctionality.category.rawValue }).first,
            ammount != "0" || ammount != "",
            let aAmmount = Double(ammount)
        else {
            let alert = UIAlertController(title: Key.alertTitle, message: Key.alertText, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: Key.alertButton, style: .default))
            view.present(alert, animated: true)
            return
        }
        
        stash.addTransaction(isExpense: aIsExpense.row == 0, ammount: aAmmount, account: accounts[aAccount.row], category: (isExpense ? catExpense : catIncome)[aCategory.row], date: Date())
        router.back()
    }
    
    
        //MARK: - Table Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRows = tableView.indexPathsForSelectedRows
        let selectedCell = selectedRows?.filter({ $0.section == indexPath.section }).first
        if let selectedCell = selectedCell, selectedCell != indexPath {
            tableView.deselectRow(at: selectedCell, animated: true)
        }
        
        if indexPath.section == TransactionCellFunctionality.isExpense.rawValue {
            isExpense = indexPath.row == 0
            tableView.reloadSections([TransactionCellFunctionality.category.rawValue], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let selectedRows = tableView.indexPathsForSelectedRows
        let selectedCell = selectedRows?.filter({ $0 == indexPath }).first
        if selectedCell != nil {
            return nil
        }
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         view.tintColor = .darkGray

        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = .white
    }
}

extension QTransactionPresenter: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            ammount = updatedText
        }

        return true
    }
}


enum TransactionCellFunctionality: Int, CaseIterable {
    case isExpense = 0
    case ammount
    case account
    case category
    
    var text: String {
        switch self {
        case .isExpense:
            return "Is expense"
        case .ammount:
            return "Ammount"
        case .account:
            return "Account"
        case .category:
            return "Category"
        }
    }
}

fileprivate struct Key {
    static let alertTitle = "Error"
    static let alertText = "You must select all the fields"
    static let alertButton = "OK"
    
    static let textPlaceholder = "Enter transaction ammount"
}
