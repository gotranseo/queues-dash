//
//  File.swift
//  
//
//  Created by Jimmy McDermott on 10/11/20.
//

import Foundation
import Vapor
import QueuesDatabaseHooks

struct DashboardViewContext: Codable {
    let currentJobData: CurrentJobsStatusResponse
    let completedJobData: CompletedJobStatusResponse
    let timingData: JobsTimingResponse
    let hours: Int
    let throughputValues: [GraphData]
    let executionTimeValues: [GraphData]

    struct GraphData: Codable {
        let key: String
        let value: Double
    }
}
