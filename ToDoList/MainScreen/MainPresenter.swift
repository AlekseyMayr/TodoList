//
//  MainPresenter.swift
//  ToDoList
//
//  Created by Алексей on 05.09.2025.
//

import CoreData

//MARK: - MainPresenterProtocol
protocol MainPresenterProtocol: MainPresenterLogicProtocol, MainPresenterNavigationProtocol { }

protocol MainPresenterLogicProtocol: AnyObject {
    func createFrc(searchText: String?, completion: @escaping (Result<NSFetchedResultsController<Todo>, Error>) -> Void)
    func deleteTodo(todo: Todo?, completion: @escaping (Result<Void, Error>) -> Void)
    func updateCompleted(todo: Todo?, newCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func setSearching(isActive: Bool)
    func viewDidLoaded()
}

protocol MainPresenterNavigationProtocol: AnyObject {
    func showDetailScreen(data: Todo?, count: Int?)
}

//MARK: - MainPresenter
final class MainPresenter: MainPresenterProtocol {
    var router: MainRouterProtocol
    var interactor: MainInteractorProtocol
    private var isSearching = false
    
    //MARK: - Initializer
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    //MARK: - Methods
    func setSearching(isActive: Bool) {
        isSearching = isActive
    }
    
    func viewDidLoaded() {
        interactor.getRequest()
    }
    
    func createFrc(searchText: String?, completion: @escaping (Result<NSFetchedResultsController<Todo>, Error>) -> Void) {
        if let searchText, !searchText.isEmpty, isSearching {
            interactor.createFetchRequest(searchText: searchText, completion: completion)
        } else {
            interactor.createFetchRequest(searchText: nil, completion: completion)
        }
    }
    
    func updateCompleted(todo: Todo?, newCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        interactor.updateCompleted(todo: todo, newCompleted: newCompleted, completion: completion)
    }
    
    func deleteTodo(todo: Todo?, completion: @escaping (Result<Void, Error>) -> Void) {
        interactor.deleteTodo(todo: todo, completion: completion)
    }
}

extension MainPresenter: MainPresenterNavigationProtocol {
    
    func showDetailScreen(data: Todo?, count: Int?) {
        router.showDetailScreen(data: data, count: count)
    }
}
