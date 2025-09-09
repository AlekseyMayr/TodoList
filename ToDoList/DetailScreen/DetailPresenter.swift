//
//  DetailPresenter.swift
//  ToDoList
//
//  Created by Алексей on 06.09.2025.
//

import Foundation

//MARK: - DetailPresenterProtocol
protocol DetailPresenterProtocol: AnyObject {
    func saveData(titleTextView: String?, todoTextView: String?)
    func viewDidLoaded()
}

//MARK: - DetailPresenter
final class DetailPresenter: DetailPresenterProtocol {
    weak var view: DetailViewControllerProtocol?
    var interactor: DetailInteractorProtocol
    
    init(interactor: DetailInteractorProtocol) {
        self.interactor = interactor
    }
    
    func saveData(titleTextView: String?, todoTextView: String?) {
        interactor.saveData(titleTextView: titleTextView, todoTextView: todoTextView) { result in
            switch result {
            case .success(()):
                print("Задача сохранена")
            case .failure(let error):
                print("Unresolved error \(error.localizedDescription)")
            }
        }
    }
    
    func viewDidLoaded() {
        let data = interactor.todo
        view?.configureDetail(with: data)
    }
}
