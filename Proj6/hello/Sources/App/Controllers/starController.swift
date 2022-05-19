import Vapor
import Fluent
import Leaf

// struct StarContent: Content {
//             var name: String
//             var galaxyName: String
// }

func starsController(_ app: Application) throws {
    let stars = app.grouped("stars")

    // GET main page with stars
    stars.get { req async throws -> View in
        let stars = try await Star.query(on: req.db).all()
        print("foo")
        print(stars)
        
        return try await req.view.render("star", ["stars": stars])
    }

    // POST /stars create new star
    stars.post { req throws -> Response in
        
        // let starcontent = try req.content.decode(StarContent.self)
        // let star = Star()
        // star.create(on: req.db).map { starcontent }

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
        return try await req.view.render("starEdit", ["star": star])
    }

    // POST /stars/:id edit star
    stars.post(":id") { req async throws -> Response in
        // let patch = try req.content.decode(StarContent.self)

        guard let star = try await Star.find(req.parameters.get("id"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await star.update(on: req.db)
        return req.redirect(to: "/stars")
    }

}