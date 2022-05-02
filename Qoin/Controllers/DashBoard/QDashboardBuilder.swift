//
//  QDashboardBuilder.swift
//  Qoin
//
//  Created by Maksym S. on 28.04.2022.
//

import Foundation

struct QDashboardBuilder {
    func create() -> QDashboardVC {
        let vc = QDashboardVC()
        let router = QRouter(vc: vc)
        let presenter = QDashboardPresenter(view: vc, router: router)
        vc.presenter = presenter
        return vc
    }
}
