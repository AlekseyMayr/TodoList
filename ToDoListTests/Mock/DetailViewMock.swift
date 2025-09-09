//
//  ExtensionDetailPresenterTests.swift
//  ToDoListTests
//
//  Created by Алексей on 07.09.2025.
//

import Foundation
@testable import ToDoList

final class DetailViewMock: DetailViewControllerProtocol {
    var configureDetailCalled = false
    var passedData: Todo?
    
    func configureDetail(with todo: Todo?) {
        configureDetailCalled = true
        passedData = todo
    }
}
