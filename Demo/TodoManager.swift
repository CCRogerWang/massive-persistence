//
//  TodoManager.swift
//  Demo
//
//  Created by Roger on 2021/3/15.
//  Copyright © 2021 TinyWorld. All rights reserved.
//

import Foundation
import CoreData

class TodoManager {
    private var persistenContainer: NSPersistentContainer?
    
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
    ///   - title: <#title description#>
    ///   - completionHandler: <#completionHandler description#>
    func createTodo(title: String, completionHandler: @escaping (Result<Todo>) -> Void) {
        
    }
    
    /// Read todos.
    /// - Parameter completionHandler: <#completionHandler description#>
    func readTodos(completionHandler: @escaping (Result<[Todo]>) -> Void) {
    }
}
