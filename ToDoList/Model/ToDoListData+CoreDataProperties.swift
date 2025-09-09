//
//  ToDoListData+CoreDataProperties.swift
//  
//
//  Created by Алексей on 03.09.2025.
//
//

import Foundation
import CoreData


extension ToDoListData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListData> {
        return NSFetchRequest<ToDoListData>(entityName: "ToDoListData")
    }

    @NSManaged public var limit: Int16
    @NSManaged public var skip: Int16
    @NSManaged public var total: Int16
    @NSManaged public var todos: Set<Todo>

}

// MARK: Generated accessors for todos
extension ToDoListData {

    @objc(addTodosObject:)
    @NSManaged public func addToTodos(_ value: Todo)

    @objc(removeTodosObject:)
    @NSManaged public func removeFromTodos(_ value: Todo)

    @objc(addTodos:)
    @NSManaged public func addToTodos(_ values: NSSet)

    @objc(removeTodos:)
    @NSManaged public func removeFromTodos(_ values: NSSet)

}
