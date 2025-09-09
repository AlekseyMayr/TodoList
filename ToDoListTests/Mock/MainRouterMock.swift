//
//  MainRouterMock.swift
//  ToDoListTests
//
//  Created by Алексей on 09.09.2025.
//

import CoreData
@testable import ToDoList

final class MainRouterMock: MainRouterProtocol {
    var showDetailScreenCalled = false
    var passedData: Todo?
    var passedCount: Int?
    
    func showDetailScreen(data: Todo?, count: Int?) {
        showDetailScreenCalled = true
        passedData = data
        passedCount = count
    }
}
