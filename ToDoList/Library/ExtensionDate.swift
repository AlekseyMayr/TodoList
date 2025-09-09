//
//  Date.swift
//  ToDoList
//
//  Created by Алексей on 04.09.2025.
//

import Foundation

extension Date {
    func convertDateToString() -> String {
       let dateForm = DateFormatter()
       dateForm.dateFormat = "dd/MM/yy"
       let stringDate = dateForm.string(from: self)
       return stringDate
   }
}
