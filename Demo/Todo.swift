//
//  Todo.swift
//  Demo
//
//  Created by Roger on 2021/3/15.
//  Copyright © 2021 TinyWorld. All rights reserved.
//

import Foundation

struct Todo {
    let title: String
    let createdAtDate: Date
}

extension Todo {
    
    /// Convert TodoEntity(CoreData) to Todo
    /// - Parameter entity: TodoEntity
    /// - Throws: error
    init(entity: TodoEntity) throws {
        guard let title = entity.title else {
            throw EntityError.missingValueForKey("title")
        }
        guard let createdAtDate = entity.createdAtDate else {
            throw EntityError.missingValueForKey("createdAtDate")
        }
        self.init(title: title, createdAtDate: createdAtDate)
    }
}
