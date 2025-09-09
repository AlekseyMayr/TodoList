//
//  DetailPresenterTests.swift
//  ToDoListTests
//
//  Created by Алексей on 07.09.2025.
//

import XCTest
@testable import ToDoList

final class DetailPresenterTests: XCTestCase {
    var viewMock: DetailViewMock!
    var interactorMock: DetailInteractorMock!
    var presenter: DetailPresenter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        viewMock = DetailViewMock()
        interactorMock = DetailInteractorMock()
        presenter = DetailPresenter(interactor: interactorMock)
        presenter.view = viewMock
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewMock = nil
        interactorMock = nil
        presenter = nil
    }
    
    func test_saveData() {
        //GET
        let title = "test title"
        let todo = "test todo"
        
        //WHEN
        presenter.saveData(titleTextView: title, todoTextView: todo)
        
        //THEN
        XCTAssertTrue(interactorMock.saveDataCalled)
        XCTAssertEqual(interactorMock.savedTitle, title)
        XCTAssertEqual(interactorMock.savedTodoText, todo)
    }
    
    func test_viewDidLoaded() {
        //GET
        let todo = Todo()
        
        //WHEN
        interactorMock.todo = todo
        presenter.viewDidLoaded()
        
        //THEN
        XCTAssertTrue(viewMock.configureDetailCalled)
        XCTAssertEqual(viewMock.passedData, todo)
    }
}
