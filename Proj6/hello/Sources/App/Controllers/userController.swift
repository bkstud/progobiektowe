import Vapor
import Fluent
import Leaf

func usersController(_ app: Application) throws {
    let users = app.grouped("users")
    
    // GET main page with users
    users.get { req async throws -> View in
        let users = try await User.query(on: req.db).all()
        return try await req.view.render("users", ["users": users])
    }

    // POST /users create new user
    users.post { req throws -> Response in
        let user = try req.content.decode(User.self)
        if user.firstname != "" && user.surname != "" {
            user.create(on: req.db).map { user }
        }
        return req.redirect(to: "/users")
    }
    
    // Delete specific user by id
    users.post("delete", ":id") { req async throws -> Response in
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await user.delete(on: req.db)
        return req.redirect(to: "/users")
    }

    // GET /users/:id
    users.get(":id") {req async throws -> View in 
        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await req.view.render("userEdit", ["user": user])
    }
    
    // POST /users/:id edit user
    users.post(":id") { req async throws -> Response in
        let patch = try req.content.decode(User.self)

        guard let user = try await User.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        if let firstname = patch.firstname {
            if firstname != "" {
                user.firstname = firstname
            }
        }
    
        if let surname = patch.surname {
            if surname != "" {
                user.surname = surname
            }
        }
        try await user.update(on: req.db)
        return req.redirect(to: "/users")
    }

}