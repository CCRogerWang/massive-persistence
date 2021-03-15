//
//  Result.swift
//  Demo
//
//  Created by Roger on 2021/3/15.
//  Copyright © 2021 TinyWorld. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(value: T)
    case failure(error: Error)
}
