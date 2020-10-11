//
//  File.swift
//  
//
//  Created by Jimmy McDermott on 10/11/20.
//

import Foundation
import Vapor
import QueuesDatabaseHooks

struct JobsViewContext: Codable {
    let hours: Int
    let filter: Int
    let jobs: [QueueDatabaseEntry]
}
