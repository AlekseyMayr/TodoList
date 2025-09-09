//
//  MainRouterTests.swift
//  ToDoListTests
//
//  Created by Алексей on 08.09.2025.
//

import XCTest
@testable import ToDoList

final class MainRouterTests: XCTestCase {
    var navigationControllerMock: NavigationControllerMock!
    var router: MainRouter!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        navigationControllerMock = NavigationControllerMock()
        router = MainRouter(navigationController: navigationControllerMock)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        navigationControllerMock = nil
        router = nil
    }
    
    func test_showDetailScreen() {
        //GET
        let data: Todo? = Todo()
        let count = 5
        
        //WHEN
        router.showDetailScreen(data: data, count: count)
        
        //THEN
        XCTAssertNotNil(navigationControllerMock.pushedViewController)
        XCTAssertEqual(navigationControllerMock.pushAnimated, true)
    }
}
