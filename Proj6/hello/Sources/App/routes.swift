import Vapor
import Leaf

func routes(_ app: Application) throws {
    
    try usersController(app)
    try galaxiesController(app)
    try starsController(app)

    app.get { req async throws -> View in
        return try await req.view.render("mainPage")
    }

}
