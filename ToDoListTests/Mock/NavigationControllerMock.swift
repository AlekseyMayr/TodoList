//
//  ExtensionMainRouterTests.swift
//  ToDoListTests
//
//  Created by Алексей on 08.09.2025.
//

import UIKit
@testable import ToDoList

final class NavigationControllerMock: UINavigationController {
    var pushedViewController: UIViewController?
    var pushAnimated: Bool?
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushedViewController = viewController 
        pushAnimated = animated
    }
}
