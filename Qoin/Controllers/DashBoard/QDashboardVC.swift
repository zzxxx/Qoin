//
//  QDashboardVC.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import UIKit

protocol QDashboardViewProtocol: AnyObject {
    
}

class QDashboardVC: UITableViewController, QDashboardViewProtocol {
    
    var presenter: QDashboardPresenterProtocol!
    
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = Key.screenTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.willAppear()
        tableView.reloadData()
    }
    
    //MARK: - Actions
    @objc func addTapped() {
        presenter.addPressed()
    }
}

extension QDashboardVC {
    //MARK: - Tableview Datasource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return presenter.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems(inSection: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: Key.cellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value2, reuseIdentifier: Key.cellIdentifier)
        }
        guard let cell = cell else { fatalError("Cell is not available") }
        
        presenter.fill(cell: cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        presenter.sectionTitle(atIndex: section)
    }
    
    //MARK: - Tableview Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.tableView(tableView, didSelectRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.tableView(tableView, commit: editingStyle, forRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        presenter.tableView(tableView, willDisplayHeaderView: view, forSection: section)
    }
}

fileprivate struct Key {
    static let cellIdentifier = "TransactionCellIdentifier"
    static let screenTitle = "Dashboard"
}
