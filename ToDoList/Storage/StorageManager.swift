//
//  StorageManager.swift
//  ToDoList
//
//  Created by Алексей on 04.09.2025.
//

import CoreData

//MARK: - StorageManager
class StorageManager {
    static let shared = StorageManager()
    private init() { }
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        container.loadPersistentStores { store, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                container.viewContext.automaticallyMergesChangesFromParent = true
            }
        }
        return container
    }()
    
    func saveViewContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Create
    func createTodoList(id: Int16, userId: Int16, title: String, date: Date?, todo: String?, completed: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        backgroundContext.perform {
            let todoList = Todo(context: context)
            todoList.id = id
            todoList.userId = userId
            todoList.title = title
            todoList.date = date
            todoList.todo = todo
            todoList.completed = completed
            if context.hasChanges {
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    // MARK: - Read
    func fetchTodoList(searchText: String?, completion: @escaping (Result<NSFetchedResultsController<Todo>, Error>) -> Void) {
        backgroundContext.perform { [weak self] in
            guard let self else { return }
            let fetchRequest = Todo.fetchRequest()
            if let searchText, !searchText.isEmpty {
                fetchRequest.predicate = NSPredicate(format: "todo CONTAINS[cd] %@", searchText)
            }
            let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            do {
                try fetchedResultsController.performFetch()
                DispatchQueue.main.async {
                    completion(.success(fetchedResultsController))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - Update
    func updateCompleted(todo: Todo?, newCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Todo.fetchRequest()
            guard let id = todo?.id else { return }
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            do {
                let todos = try? context.fetch(fetchRequest)
                if let todo = todos?.first {
                    todo.completed = newCompleted
                }
            }
            if context.hasChanges {
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func updateToDoList(todo: Todo, newTitle: String, newDate: Date, newTodo: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Todo.fetchRequest()
            let id = todo.id
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            do {
                let todos = try? context.fetch(fetchRequest)
                if let todo = todos?.first {
                    guard todo.title != newTitle || todo.todo != newTodo else { return }
                    todo.title = newTitle
                    todo.date = newDate
                    todo.todo = newTodo
                }
            }
            if context.hasChanges {
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    // MARK: - Delete
    
    func deleteTodo(todo: Todo?, completion: @escaping (Result<Void, Error>) -> Void) {
        let context = backgroundContext
        backgroundContext.perform {
            let fetchRequest = Todo.fetchRequest()
            guard let id = todo?.id else { return }
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            do {
                let todos = try? context.fetch(fetchRequest)
                if let todo = todos?.first {
                    context.delete(todo)
                }
            }
            if context.hasChanges {
                do {
                    try context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
