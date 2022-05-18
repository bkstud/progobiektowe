import Vapor
import Leaf
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    app.views.use(.leaf)
    app.migrations.add(CreateGalaxy())
    app.migrations.add(CreateStar())
    app.migrations.add(CreateUser())
    app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
    // register routes
    try routes(app)
}
