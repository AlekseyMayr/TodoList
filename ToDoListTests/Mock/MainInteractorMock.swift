//
//  Exyension.swift
//  ToDoListTests
//
//  Created by Алексей on 07.09.2025.
//

import CoreData
@testable import ToDoList

final class MainInteractorMock: MainInteractorProtocol {
    var getRequestCalled = false
    var createFetchRequestCalled = false
    var deleteTodoCalled = false
    var updateCompletedCalled = false
    var deleteTodo: Todo?
    var updateTodo: Todo?
    var searchControllerText: String?
    var updateNewCompleted: Bool?
    
    func createFetchRequest(searchText: String?, completion: @escaping (Result<NSFetchedResultsController<ToDoList.Todo>, any Error>) -> Void) {
        createFetchRequestCalled = true
        searchControllerText = searchText
        let frc = NSFetchedResultsController<Todo>()
        completion(.success(frc))
    }
    
    func updateCompleted(todo: ToDoList.Todo?, newCompleted: Bool, completion: @escaping (Result<Void, any Error>) -> Void) {
        updateCompletedCalled = true
        updateTodo = todo
        updateNewCompleted = newCompleted
        completion(.success(()))
    }
    
    func deleteTodo(todo: ToDoList.Todo?, completion: @escaping (Result<Void, any Error>) -> Void) {
        deleteTodoCalled = true
        deleteTodo = todo
        completion(.success(()))
    }
    
    func getRequest() {
        getRequestCalled = true
    }
}
