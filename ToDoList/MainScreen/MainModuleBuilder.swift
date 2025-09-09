//
//  MainModuleBuilder.swift
//  ToDoList
//
//  Created by Алексей on 04.09.2025.
//

import UIKit

final class MainModuleBuilder {
    static func build(navigationController: UINavigationController) -> MainViewController {
        let apiManager = ApiManager()
        let interactor = MainInteractor(apiManager: apiManager)
        let router = MainRouter(navigationController: navigationController)
        let presenter = MainPresenter(router: router, interactor: interactor)
        let viewController = MainViewController()
        viewController.presenter = presenter
        return viewController
    }
}
