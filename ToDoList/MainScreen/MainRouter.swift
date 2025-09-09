//
//  MainRouter..swift
//  ToDoList
//
//  Created by Алексей on 05.09.2025.
//

import UIKit

//MARK: - MainRouterProtocol
protocol MainRouterProtocol: AnyObject {
    func showDetailScreen(data: Todo?, count: Int?)
}

//MARK: - MainRouter
final class MainRouter: MainRouterProtocol {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetailScreen(data: Todo?, count: Int?) {
        let controller = DetailModuleBuilder.build(data: data, count: count)
        navigationController.pushViewController(controller, animated: true)
    }
}
