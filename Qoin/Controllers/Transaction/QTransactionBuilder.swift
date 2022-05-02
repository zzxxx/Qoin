//
//  QTransactionBuilder.swift
//  Qoin
//
//  Created by Maksym S. on 29.04.2022.
//

import Foundation

struct QTransactionBuilder {
    func create() -> QTransactionVC {
        let vc = QTransactionVC()
        let router = QRouter(vc: vc)
        let presenter = QTransactionPresenter(view: vc, router: router)
        vc.presenter = presenter
        return vc
    }
}
