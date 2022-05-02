//
//  QTransactionVC.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import UIKit

protocol QTransactionViewProtocol where Self: UIViewController {
    
}

class QTransactionVC: UITableViewController, QTransactionViewProtocol {
    
    
    var presenter: QTransactionPresenterProtocol!
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelection = true
        tableView.allowsMultipleSelectionDuringEditing = true
        tableView.keyboardDismissMode = .onDrag
        tableView.register(QTransactionTableViewCell.self, forCellReuseIdentifier: Key.cellIdentifier)
        tableView.register(QTransactionAmmountCell.self, forCellReuseIdentifier: Key.cellAmmountIdentifier)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(addTapped))
        presenter.screenLoaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    //MARK: - Action
    @objc func addTapped() {
        presenter.addPressed(tableView)
    }
}


extension QTransactionVC {
    //MARK: - Tableview Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == TransactionCellFunctionality.ammount.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: Key.cellAmmountIdentifier)
            guard let cell = cell as? QTransactionAmmountCellProtocol else { fatalError("Cell is not available") }
            presenter.fill(ammountCell: cell)
            return cell
        }
            
        let cell = tableView.dequeueReusableCell(withIdentifier: Key.cellIdentifier)
        guard let cell = cell else { fatalError("Cell is not available") }
        
        presenter.fill(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter.sectionTitle(atIndex: section)
    }
    
    //MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        presenter.tableView(tableView, willDeselectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        presenter.tableView(tableView, willDisplayHeaderView: view, forSection: section)
    }
}

fileprivate struct Key {
    static let cellIdentifier = "TransactionCellIdentifier"
    static let cellAmmountIdentifier = "QTransactionAmmountCell"
}
