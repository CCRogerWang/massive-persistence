//
//  Todo.swift
//  Demo
//
//  Created by Roy Hsu on 2018/5/21.
//  Copyright © 2018 TinyWorld. All rights reserved.
//

// MARK: - Todo

import Foundation

struct Todo {
    
    let title: String
    
    let createdAtDate: Date
    
}

// MARK: - Core Data

extension Todo {

    init(entity: TodoEntity) throws {
        
        guard
            let title = entity.title
        else { throw EntityError.missingValueForKey("title") }
        
        guard
            let createdAtDate = entity.createdAtDate
        else { throw EntityError.missingValueForKey("createdAtDate") }
        
        self.init(
            title: title,
            createdAtDate: createdAtDate
        )
        
    }
    
}
