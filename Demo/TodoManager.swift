//
//  TodoManager.swift
//  Demo
//
//  Created by Roy Hsu on 2018/5/21.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - TodoManager

import CoreData

class TodoManager: TodoProvider {
    
    private var persistentContainer: NSPersistentContainer?
    
    func loadStore(
        name: String,
        completionHandler: @escaping (Result<Void>) -> Void
    ) {
        
        let container = NSPersistentContainer(name: name)
        
        let description = NSPersistentStoreDescription()
        
        // Development only.
        description.type = NSInMemoryStoreType
        
        container.persistentStoreDescriptions = [ description ]
        
        container.loadPersistentStores { [weak self] description, error in
            
            if let error = error {
                
                completionHandler(
                    .failure(error: error)
                )
                
                return
                
            }
            
            let result: Void = ()
            
            completionHandler(
                .success(value: result)
            )
            
            self?.persistentContainer = container
            
        }
        
    }
    
    enum CreateTodoError: Error {
        
        case noStore
        
    }
    
    func createTodo(
        title: String,
        completionHandler: @escaping (Result<Todo>) -> Void
    ) {
        
        guard
            let container = persistentContainer
        else {
            
            let error: CreateTodoError = .noStore
            
            completionHandler(
                .failure(error: error)
            )
            
            return
                
        }
        
        container.performBackgroundTask { backgroundContext in
            
            guard
                let description = NSEntityDescription.entity(
                    forEntityName: "Todo",
                    in: backgroundContext
                )
            else { fatalError("CANNOT find the entity description for Todo.") }
            
            backgroundContext.perform {
                
                let todoEntity = TodoEntity(
                    entity: description,
                    insertInto: backgroundContext
                )
                
                todoEntity.title = title
                
                todoEntity.createdAtDate = Date()
                
                do {
                    
                    try backgroundContext.save()
                    
                    let todo = try Todo(entity: todoEntity)
                    
                    completionHandler(
                        .success(value: todo)
                    )
                    
                }
                catch {
                    
                    completionHandler(
                        .failure(error: error)
                    )
                    
                }
                
            }
            
        }
        
    }
    
    enum ReadTodosError: Error {
        
        case noStore
        
    }
    
    func readTodos(
        completionHandler: @escaping (Result<[Todo]>) -> Void
    ) {
        
        guard
            let container = persistentContainer
        else {
            
            let error: ReadTodosError = .noStore
            
            completionHandler(
                .failure(error: error)
            )
            
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

                // Hard version.
                let todos = try todoEntities.map(Todo.init)
                
                // Easy version.
//                var todos: [Todo] = []
//
//                for todoEntity in todoEntities {
//
//                    let todo = Todo(entity: todoEntity)
//
//                    todos.append(todo)
//
//                }
                
                completionHandler(
                    .success(value: todos)
                )

            }
            catch {
                
                completionHandler(
                    .failure(error: error)
                )
                
            }

        }
        
    }
    
}
