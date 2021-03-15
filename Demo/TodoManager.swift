//
//  TodoManager.swift
//  Demo
//
//  Created by Roger on 2021/3/15.
//  Copyright © 2021 TinyWorld. All rights reserved.
//

import Foundation
import CoreData

class TodoManager: TodoProvider {
    private var persistenContainer: NSPersistentContainer?
    
    enum CreateTodoError: Error {
        case noStore
    }
    
    enum ReadTodosError: Error {
        case noStore
    }
    
    /// load store
    /// - Parameters:
    ///   - name: String
    ///   - completetionHandler: (Result<Void>) -> Void)
    func loadStore(name: String, completionHandler: @escaping (Result<Void>) -> Void) {
        let container = NSPersistentContainer(name: name)
        let description = NSPersistentStoreDescription()
        // dev only
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (desc, err) in
            if let err = err {
                completionHandler(.failure(error: err))
            } else {
                let result: Void = ()
                completionHandler(.success(value: result))
                self.persistenContainer = container
            }
        }
    }
    
    /// Create a todo
    /// - Parameters:
    ///   - title: String
    ///   - completionHandler: @escaping (Result<Todo>) -> Void
    func createTodo(title: String, completionHandler: @escaping (Result<Todo>) -> Void) {
        guard let container = persistenContainer else {
            let error: CreateTodoError = .noStore
            completionHandler(.failure(error: error))
            return
        }
        
        container.performBackgroundTask { backgroundContext in
            
            guard let description = NSEntityDescription.entity(forEntityName: "Todo",in: backgroundContext) else { fatalError("CANNOT find the entity description for Todo.")
            }
            
            backgroundContext.perform {
                
                let todoEntity = TodoEntity(entity: description, insertInto: backgroundContext)
                todoEntity.title = title
                todoEntity.createdAtDate = Date()
                
                do {
                    try backgroundContext.save()
                    let todo = try Todo.init(entity: todoEntity)
                    completionHandler(.success(value: todo))
                } catch {
                    completionHandler(.failure(error: error))
                }
                
                
            }
            
        }
    }
    
    /// Read todos.
    /// - Parameter completionHandler: <#completionHandler description#>
    func readTodos(completionHandler: @escaping (Result<[Todo]>) -> Void) {
        guard let container = persistenContainer else {
            let error: ReadTodosError = .noStore
            completionHandler(.failure(error: error))
            return
        }
        
        container.viewContext.perform {
            let fetchRequest: NSFetchRequest<TodoEntity> = TodoEntity.fetchRequest()
            
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(
                    key: "createdAtDate",
                    ascending: false
                )
            ]
            
            do {
                let todoEntities = try container.viewContext.fetch(fetchRequest)
                let todos = try todoEntities.map(Todo.init)
                completionHandler(.success(value: todos))
            } catch {
                completionHandler(.failure(error: error))
            }
        }
    }
}
