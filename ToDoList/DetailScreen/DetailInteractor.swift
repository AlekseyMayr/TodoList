//
//  DetailInteractor.swift
//  ToDoList
//
//  Created by Алексей on 05.09.2025.
//

import Foundation

//MARK: - DetailInteractorProtocol
protocol DetailInteractorProtocol: AnyObject {
    func saveData(titleTextView: String?, todoTextView: String?, completion: @escaping (Result<Void, Error>) -> Void)
    var todo: Todo? { get }
}

//MARK: - DetailInteractor
final class DetailInteractor: DetailInteractorProtocol {
    var todo: Todo?
    var count: Int?
    
    init(todo: Todo?, count: Int?) {
        self.todo = todo
        self.count = count
    }

    func saveData(titleTextView: String?, todoTextView: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let date = Date()
        if let todo = todo {
            guard let titleTextView, let todoTextView, !titleTextView.isEmpty || !todoTextView.isEmpty else {
                deleteTodo(todo: todo, completion: completion)
                return
            }
            updateTodo(todo: todo, newTitle: titleTextView, newDate: date, newTodo: todoTextView, completion: completion)
        } else {
            let id = (count ?? 0) + 1
            print("принт", id)
            let date = Date()
            guard let titleTextView, let todoTextView, !titleTextView.isEmpty || !todoTextView.isEmpty else {
                return
            }
            createTodo(id: Int16(id), userId: Int16(id), title: titleTextView, date: date, todo: todoTextView, completed: false, completion: completion)
        }
    }
    
    func createTodo(id: Int16, userId: Int16, title: String, date: Date?, todo: String?, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        StorageManager.shared.createTodoList(id: id, userId: userId, title: title, date: date, todo: todo, completed: completed, completion: completion)
    }
    
    func updateTodo(todo: Todo, newTitle: String, newDate: Date, newTodo: String, completion: @escaping (Result<Void, Error>) -> Void) {
        StorageManager.shared.updateToDoList(todo: todo, newTitle: newTitle, newDate: newDate, newTodo: newTodo, completion: completion)
    }
    
    func deleteTodo(todo: Todo?, completion: @escaping (Result<Void, Error>) -> Void) {
        StorageManager.shared.deleteTodo(todo: todo, completion: completion)
    }
}
