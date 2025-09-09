//
//  ToDoListTests.swift
//  ToDoListTests
//
//  Created by Алексей on 03.09.2025.
//

import XCTest
import CoreData
@testable import ToDoList

final class MainPresenterTests: XCTestCase {
    var presenter: MainPresenter!
    var routerMock: MainRouterMock!
    var interactorMock: MainInteractorMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        routerMock = MainRouterMock()
        interactorMock = MainInteractorMock()
        presenter = MainPresenter(router: routerMock, interactor: interactorMock)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        presenter = nil
        routerMock = nil
        interactorMock = nil
    }

    func test_viewDidLoaded() {
        //WHEN
        presenter.viewDidLoaded()
        
        //THEN
        XCTAssertTrue(interactorMock.getRequestCalled)
    }

    func test_createFrc_withSearch() {
        //GET
        presenter.setSearching(isActive: true)
        let searchText = "test"
        let expectation = expectation(description: #function)

        //WHEN
        presenter.createFrc(searchText: searchText) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        //THEN
        XCTAssertTrue(interactorMock.createFetchRequestCalled)
        XCTAssertEqual(interactorMock.searchControllerText, searchText)
    }
    
    func test_createFrc_withoutSearch() {
        //GET
        presenter.setSearching(isActive: false)
        let expectation = expectation(description: #function)

        //WHEN
        presenter.createFrc(searchText: nil) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        //THEN
        XCTAssertTrue(interactorMock.createFetchRequestCalled)
        XCTAssertNil(interactorMock.searchControllerText)
    }
    
    func test_updateCompleted() {
        //GET
        let todo = Todo()
        let expectation = expectation(description: #function)
        
        //WHEN
        presenter.updateCompleted(todo: todo, newCompleted: true) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        //THEN
        XCTAssertTrue(interactorMock.updateCompletedCalled)
        XCTAssertEqual(interactorMock.updateTodo, todo)
        XCTAssertEqual(interactorMock.updateNewCompleted, true)
    }
    
    func test_deleteTodo() {
        //GET
        let todo = Todo()
        let expectation = expectation(description: #function)
        
        //WHEN
        presenter.deleteTodo(todo: todo) { _ in
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
        
        //THEN
        XCTAssertTrue(interactorMock.deleteTodoCalled)
        XCTAssertEqual(interactorMock.deleteTodo, todo)
    }
    
    func test_showDetailScreen() {
        //GET
        let count = 5
        let todo = Todo()
        
        //WHEN
        presenter.showDetailScreen(data: todo, count: count)
        
        //THEN
        XCTAssertTrue(routerMock.showDetailScreenCalled)
        XCTAssertEqual(routerMock.passedData, todo)
        XCTAssertEqual(routerMock.passedCount, 5)
    }
}
