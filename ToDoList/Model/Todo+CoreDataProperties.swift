//
//  Todo+CoreDataProperties.swift
//  
//
//  Created by Алексей on 03.09.2025.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var id: Int16
    @NSManaged public var title: String?
    @NSManaged public var todo: String?
    @NSManaged public var userId: Int16
    @NSManaged public var todoListData: ToDoListData?

}
