import Vapor
import Fluent
import Leaf

func galaxiesController(_ app: Application) throws {
    let galaxies = app.grouped("galaxies")
    
    // GET main page with galaxies
    galaxies.get { req async throws -> View in
        let galaxies = try await Galaxy.query(on: req.db).all()
        return try await req.view.render("galaxy", ["galaxies": galaxies])
    }

    // POST /galaxies create new galaxy
    galaxies.post { req throws -> Response in
        let galaxy = try req.content.decode(Galaxy.self)
        if galaxy.name != "" {
            galaxy.create(on: req.db).map { galaxy }
        }
        return req.redirect(to: "/galaxies")
    }
    
    // Delete specific galaxy by id
    galaxies.post("delete", ":id") { req async throws -> Response in
        guard let galaxy = try await Galaxy.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await galaxy.delete(on: req.db)
        return req.redirect(to: "/galaxies")
    }

    // GET /galaxies/:id
    galaxies.get(":id") {req async throws -> View in 
        guard let galaxy = try await Galaxy.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        return try await req.view.render("galaxyEdit", ["galaxy": galaxy])
    }
    
    // POST /galaxies/:id edit galaxy
    galaxies.post(":id") { req async throws -> Response in
        let patch = try req.content.decode(Galaxy.self)

        guard let galaxy = try await Galaxy.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        
        galaxy.name = patch.name

        try await galaxy.update(on: req.db)
        return req.redirect(to: "/galaxies")
    }

}