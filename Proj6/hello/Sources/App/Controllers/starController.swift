import Vapor
import Fluent
import Leaf

struct StarContent: Content {
            var name: String
            var galaxyName: String
}

func starsController(_ app: Application) throws {
    let stars = app.grouped("stars")

    // GET main page with stars
    stars.get { req async throws -> View in
        let stars = try await Star.query(on: req.db).all()
        // Load each star parent
        for star in stars {
            try await star.$galaxy.get(on: req.db)
        }
        return try await req.view.render("star", ["stars": stars])
    }

    // POST /stars create new star
    stars.post { req async throws -> Response in
        // Decode content
        let starcontent = try req.content.decode(StarContent.self)
        // find galaxy
        var galaxy = try await Galaxy.query(on: req.db)
            .filter(\.$name == starcontent.galaxyName)
            .first()

        // if not found create new
        if galaxy == nil {
            let newGalaxy = Galaxy()
            newGalaxy.name = starcontent.galaxyName
            try await newGalaxy.create(on: req.db)
            galaxy = newGalaxy
        }
        let galaxyId = galaxy?.id

        let star = Star(name: starcontent.name, galaxyID: galaxyId!)
        if try await Star.query(on: req.db)
            .filter(\.$name == star.name)
            .first() == nil {
            try await star.create(on: req.db)
        }

        return req.redirect(to: "/stars")
    }

    // Delete specific star by id
    stars.post("delete", ":id") { req async throws -> Response in
        guard let star = try await Star.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await star.delete(on: req.db)
        return req.redirect(to: "/stars")
    }

    // GET /stars/:id
    stars.get(":id") {req async throws -> View in
        guard let star = try await Star.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await star.$galaxy.get(on: req.db)
        return try await req.view.render("starEdit", ["star": star])
    }

    // POST /stars/:id edit star
    stars.post(":id") { req async throws -> Response in
        let starcontent = try req.content.decode(StarContent.self)

        guard let star = try await Star.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }
        try await star.$galaxy.get(on: req.db)
        star.name = starcontent.name
        star.galaxy.name = starcontent.galaxyName
        do {
            try await star.update(on: req.db)
            try await star.galaxy.update(on: req.db)
        } catch {}
        return req.redirect(to: "/stars")
    }

}