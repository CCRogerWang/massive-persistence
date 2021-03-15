//
//  TodoProvider.swift
//  Demo
//
//  Created by Roger on 2021/3/15.
//  Copyright © 2021 TinyWorld. All rights reserved.
//

//import CoreData

protocol TodoProvider {
    func loadStore(name: String, completionHandler: @escaping (Result<Void>) -> Void)

    func createTodo(title: String, completionHandler: @escaping (Result<Todo>) -> Void)
    
    func readTodos(completionHandler: @escaping (Result<[Todo]>) -> Void)
}
