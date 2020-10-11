import Vapor
import Leaf
import QueuesDatabaseHooks

func routes(_ app: Application) throws {
    try app.routes.register(collection: DashboardController())
}
