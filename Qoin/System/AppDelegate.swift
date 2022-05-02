//
//  AppDelegate.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if QDBService.getCountOfAccounts() < 2 {
            makeFish()
        }
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    fileprivate func makeFish() {
        

        
        let qa1 = QAccount()
        qa1.id = 0
        qa1.title = "Cash"
        qa1.order = 0
        qa1.transactions.append(objectsIn: qt())
        
        
        let qa2 = QAccount()
        qa2.id = 1
        qa2.title = "Crypto"
        qa2.order = 1
        qa2.transactions.append(objectsIn: qt())
        
        let qa3 = QAccount()
        qa3.id = 2
        qa3.title = "Credit card"
        qa3.order = 2
        qa3.transactions.append(objectsIn: qt())
        
        QDBService.save([qa1,qa2,qa3])
    }
    
    func qt() -> [QTransaction] {
        let qcPlus = qcPlus()
        let qcMinus = qcMinus()
        QDBService.save(qcPlus)
        QDBService.save(qcMinus)
        
        
        let qt1 = QTransaction()
        qt1.ammount = .random(in: 1...200).rounded()
        qt1.isExpense = true
        qt1.date = Date.random()
        qt1.categories.append(qcMinus.randomElement()!)
        
        
        let qt2 = QTransaction()
        qt2.ammount = .random(in: 1...200).rounded()
        qt2.isExpense = true
        qt2.date = Date.random()
        qt2.categories.append(qcMinus.randomElement()!)
        
        let qt3 = QTransaction()
        qt3.ammount = .random(in: 1...200).rounded()
        qt3.isExpense = true
        qt3.date = Date.random()
        qt3.categories.append(qcMinus.randomElement()!)
        
        let qt4 = QTransaction()
        qt4.ammount = .random(in: 1...200).rounded()
        qt4.isExpense = true
        qt4.date = Date.random()
        qt4.categories.append(qcMinus.randomElement()!)
        
        let qt5 = QTransaction()
        qt5.ammount = .random(in: 1...1000).rounded()
        qt5.isExpense = false
        qt5.date = Date.random()
        qt5.categories.append(qcPlus.first!)
        
        let qt6 = QTransaction()
        qt6.ammount = .random(in: 1...1000).rounded()
        qt6.isExpense = false
        qt6.date = Date.random()
        qt6.categories.append(qcPlus.last!)
        
        return [qt1, qt2, qt3, qt4, qt5, qt6]
    }
    
    func qcMinus() -> [QCategory] {
        let qc1 = QCategory()
        qc1.id = 0
        qc1.title = "Food"
        qc1.order = 0
        
        let qc2 = QCategory()
        qc2.id = 1
        qc2.title = "Other"
        qc2.order = 1
        
        let qc3 = QCategory()
        qc3.id = 2
        qc3.title = "Transport"
        qc3.order = 2
        
        let qc4 = QCategory()
        qc4.id = 3
        qc4.title = "Medicine"
        qc4.order = 3
        
        let qc5 = QCategory()
        qc5.id = 4
        qc5.title = "Clothes"
        qc5.order = 4
        
        return [qc1, qc2, qc3, qc4, qc5]
    }
    
    func qcPlus() -> [QCategory] {
        let qc6 = QCategory()
        qc6.id = 5
        qc6.title = "Salary"
        qc6.order = 0
        qc6.isExpense = false
        
        let qc7 = QCategory()
        qc7.id = 6
        qc7.title = "Side hustle"
        qc7.order = 1
        qc7.isExpense = false
        
        return [qc6, qc7]
    }

}


