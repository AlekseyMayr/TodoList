//
//  MainInteractor.swift
//  ToDoList
//
//  Created by Алексей on 04.09.2025.
//

import CoreData

//MARK: - MainInteractorProtocol
protocol MainInteractorProtocol: AnyObject {
    func createFetchRequest(searchText: String?, completion: @escaping (Result<NSFetchedResultsController<Todo>, Error>) -> Void)
    func updateCompleted(todo: Todo?, newCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteTodo(todo: Todo?, completion: @escaping (Result<Void, Error>) -> Void)
    func getRequest()
}

//MARK: - MainInteractor
final class MainInteractor: MainInteractorProtocol {
    private let apiManager: ApiManagerProtocol
    private var fetchedResultsController: NSFetchedResultsController<Todo>?
    
    //MARK: - Initializer
    init(apiManager: ApiManagerProtocol) {
        self.apiManager = apiManager
    }
    
    //MARK: - Methods
    func createFetchRequest(searchText: String?, completion: @escaping (Result<NSFetchedResultsController<Todo>, Error>) -> Void) {
        StorageManager.shared.fetchTodoList(searchText: searchText, completion: completion)
    }
    
    func updateCompleted(todo: Todo?, newCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        StorageManager.shared.updateCompleted(todo: todo, newCompleted: newCompleted, completion: completion)
    }

    
    func deleteTodo(todo: Todo?, completion: @escaping (Result<Void, Error>) -> Void) {
        StorageManager.shared.deleteTodo(todo: todo, completion: completion)
    }
    
    func getRequest() {
        do {
            if try StorageManager.shared.backgroundContext.count(for: Todo.fetchRequest()) == 0 {
                apiManager.getRequest { data in
                    let context = StorageManager.shared.backgroundContext
                    let decoder = JSONDecoder()
                    decoder.userInfo[.context] = context
                    do {
                        let todoList = try decoder.decode(ToDoListData.self, from: data)
                        context.insert(todoList)
                        try context.save()
                    } catch {
                        print("Ошибка декодирования: \(error.localizedDescription)")
                    }
                }
            }
        } catch {
            print("Unresolved error: \(error.localizedDescription)")
        }
    }
}
