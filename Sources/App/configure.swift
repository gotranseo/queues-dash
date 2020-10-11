import Vapor
import Leaf
import FluentMySQLDriver
import Fluent
import FluentKit

// configures your application
public func configure(_ app: Application) throws {
    app.views.use(.leaf)
    app.leaf.cache.isEnabled = app.environment.isRelease
    app.leaf.tags["isEven"] = IsEvenTag()
    app.leaf.tags["dateFormat"] = DateFormatTag()
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    guard let databaseUrlString = Environment.get("DATABASE_URL") else { throw Abort(.internalServerError) }
    guard let databaseUrl = URL(string: databaseUrlString) else { throw Abort(.internalServerError) }
    app.databases.use(
        .mysql(
            configuration: .init(
                hostname: databaseUrl.host ?? "",
                port: databaseUrl.port ?? 0,
                username: databaseUrl.user ?? "",
                password: databaseUrl.password ?? "",
                database: databaseUrl.path.split(separator: "/").last.flatMap(String.init),
                tlsConfiguration: .forClient(certificateVerification: .none)
            ),
            maxConnectionsPerEventLoop: 30,
            connectionPoolTimeout: .minutes(1)
        ),
        as: .mysql
    )

    // register routes
    try routes(app)
}
