//
//  Todo+CoreDataClass.swift
//  
//
//  Created by Алексей on 03.09.2025.
//
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id
        case todo
        case completed
        case userId
    }
    
    public required convenience init(from decoder: Decoder) throws {
        guard let entityName = Todo.entity().name,
              let context = decoder.userInfo[.context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else {
            fatalError("Could not initialize")
        }
        self.init(entity: entity, insertInto: context)
        
        let value = try decoder.container(keyedBy: CodingKeys.self)
        id = try Int16(value.decode(Int.self, forKey: .id))
        todo = try value.decode(String.self, forKey: .todo)
        completed = try value.decode(Bool.self, forKey: .completed)
        userId = try Int16(value.decode(Int.self, forKey: .userId))
    }
}
