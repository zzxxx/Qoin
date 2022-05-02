//
//  QRouter.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import UIKit

//MARK: - Main functionality
protocol RouterDashboardProtocol  {
    func openNewTransactionScreen()
}

protocol RouterTransactionProtocol {
    func back()
}

final class QRouter: RouterProtocol, RouterDashboardProtocol, RouterTransactionProtocol {
    
    unowned let vc: UIViewController
    
    init(vc: UIViewController) {
        self.vc = vc
    }
    
    //MARK: - Dashboard
    func openNewTransactionScreen() {
        let transactionVC = QTransactionBuilder().create()
        push(viewController: transactionVC)
    }
}

//MARK: - Base
public protocol RouterProtocol {
    
    associatedtype VC: UIViewController
    var vc: VC { get }
    
}

public extension RouterProtocol {
    func push(viewController: UIViewController) {
        vc.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func present(viewController: UIViewController) {
        vc.present(viewController, animated: true)
    }
    
    func back() {
        vc.navigationController?.popViewController(animated: true)
    }
}
