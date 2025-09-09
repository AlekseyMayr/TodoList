//
//  DetailModuleBuilder.swift
//  ToDoList
//
//  Created by Алексей on 06.09.2025.
//

import Foundation

final class DetailModuleBuilder {
    static func build(data: Todo?, count: Int?) -> DetailViewController {
        let interactor = DetailInteractor(todo: data, count: count)
        let presenter = DetailPresenter(interactor: interactor)
        let viewController = DetailViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        return viewController
    }
}
