//
//  QTabBarController.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation
import UIKit

class QTabBarController: UITabBarController {
    
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dash = QDashboardBuilder().create()
        let dashNavController = UINavigationController(rootViewController: dash)
        dashNavController.tabBarItem = UITabBarItem(title: "Dashboard", image: UIImage(systemName: "cart"), selectedImage: UIImage(named: "cart.fill"))
        
        let controllers = [dashNavController]
        viewControllers = controllers
    }
    
    
    private func setUI() {
        view.backgroundColor = .white
    }
}
