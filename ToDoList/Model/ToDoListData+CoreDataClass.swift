//
//  ToDoListData+CoreDataClass.swift
//  
//
//  Created by Алексей on 03.09.2025.
//
//

import Foundation
import CoreData

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "Context")!
}

@objc(ToDoListData)
public class ToDoListData: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case total
        case skip
        case limit
        case todos
    }
    
    required convenience public init(from decoder: any Decoder) throws {
        guard let entityName = ToDoListData.entity().name,
              let context = decoder.userInfo[.context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Failed to initialize")
        }
        self.init(entity: entity, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        total = try Int16(values.decode(Int.self, forKey: .total))
        skip = try Int16(values.decode(Int.self, forKey: .skip))
        limit = try Int16(values.decode(Int.self, forKey: .limit))
        todos = try values.decode(Set<Todo>.self, forKey: .todos)
    }
}
