//
//  TodoProvider.swift
//  Demo
//
//  Created by Roy Hsu on 2018/5/21.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - TodoProvider

import CoreData

protocol TodoProvider {
    
    func loadStore(
        name: String,
        completionHandler: @escaping (Result<Void>) -> Void
    )
    
    func createTodo(
        title: String,
        completionHandler: @escaping (Result<Todo>) -> Void
    )
    
    func readTodos(
        completionHandler: @escaping (Result<[Todo]>) -> Void
    )
    
}
