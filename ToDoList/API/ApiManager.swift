//
//  ApiManager.swift
//  ToDoList
//
//  Created by Алексей on 03.09.2025.
//

import Foundation
 
//MARK: - ApiManagerProtocol
protocol ApiManagerProtocol {
    func getRequest(completion: @escaping (Data) -> Void)
}

//MARK: - ApiManager
final class ApiManager: ApiManagerProtocol {
    func getRequest(completion: @escaping (Data) -> Void) {
        let url = URL(string: "https://dummyjson.com/todos")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка сети: \(error.localizedDescription)")
                return
            }
            if let data = data {
                completion(data)
            }
        }.resume()
    }
}
