//
//  DetailInteractorMock.swift
//  ToDoListTests
//
//  Created by Алексей on 09.09.2025.
//

import Foundation
@testable import ToDoList

final class DetailInteractorMock: DetailInteractorProtocol {
    var saveDataCalled = false
    var savedTitle: String?
    var savedTodoText: String?
    var todo: Todo?
    
    func saveData(titleTextView: String?, todoTextView: String?, completion: @escaping (Result<Void, any Error>) -> Void) {
        saveDataCalled = true
        savedTitle = titleTextView
        savedTodoText = todoTextView
        completion(.success(()))
    }
}
