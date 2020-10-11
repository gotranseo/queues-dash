//
//  File.swift
//  
//
//  Created by Jimmy McDermott on 10/11/20.
//

import Foundation
import Vapor
import QueuesDatabaseHooks
import Fluent
import Leaf

struct JobsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        routes.get("jobs", use: jobs)
        routes.get("job", ":id", use: job)
    }

    func jobs(req: Request) throws -> EventLoopFuture<View> {
        let hours = (try? req.query.get(Int.self, at: "hours")) ?? 1
        let filter = (try? req.query.get(Int.self, at: "filter")) ?? -1
        guard let pastDate = Calendar.current.date(byAdding: .hour, value: hours * -1, to: Date()) else {
            throw Abort(.badRequest, reason: "Could not formulate date")
        }

        let query = QueueDatabaseEntry
            .query(on: req.db)
            .filter(\.$queuedAt >= pastDate)
            .sort(\.$status, .ascending)
            .sort(\.$queuedAt, .descending)

        if filter != -1 {
            guard let status = QueueDatabaseEntry.Status(rawValue: filter) else { throw Abort(.notFound) }
            query.filter(\.$status == status)
        }

        return query.all().flatMap { jobs in
            return req.view.render("jobs", JobsViewContext(hours: hours, filter: filter, jobs: jobs))
        }
    }

    func job(req: Request) throws -> EventLoopFuture<View> {
        let parameter = try req.parameters.require("id", as: UUID.self)
        return QueueDatabaseEntry.find(parameter, on: req.db).unwrap(or: Abort(.notFound)).flatMap { job in
            return req.view.render("job", JobViewContext(job: job))
        }
    }
}

/// Determines if the input is event
struct IsEvenTag: LeafTag {
    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let number = ctx.parameters.first?.int else {
            throw "Unable to number value"
        }

        return .init(booleanLiteral: number % 2 == 0)
    }
}

struct DateFormatTag: LeafTag {
    func render(_ ctx: LeafContext) throws -> LeafData {
        guard let number = ctx.parameters.first?.double else {
            throw "Unable to number value"
        }

        let date = Date(timeIntervalSince1970: number)
        let df = DateFormatter()
        df.timeStyle = .short
        df.dateStyle = .short

        return .init(stringLiteral: df.string(from: date))
    }
}
