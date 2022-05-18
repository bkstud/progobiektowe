import Vapor
import Fluent
import Leaf

func usersController(_ app: Application) throws {
    let users = app.grouped("users")
    
    users.get { req async throws -> View in
        let users = try await User.query(on: req.db).all()
        return try await req.view.render("users", ["users": users])
        // return "Hello, world!"
    }
    // GET /users
    // users.get {req async throws in
    //     try await User.query(on: req.db).all()
    // }

    // POST /users
    users.post { req throws -> EventLoopFuture<User> in
        let user = try req.content.decode(User.self)
        
        return user.create(on: req.db).map { user }
    }
    
    users.post("delete", ":id") { req async throws -> Response in
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return req.redirect(to: "/users")
    }

    // GET /users/:id
    users.get(":id") {req async throws -> User in 
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return user
    }

}