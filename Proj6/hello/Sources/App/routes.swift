import Vapor

func routes(_ app: Application) throws {
    
    try usersController(app)

    app.get { req in
        return "It works!"
    }

    app.get("hello") { req -> EventLoopFuture<View> in
        return req.view.render("hello", ["name": "Leaf"])
        // return "Hello, world!"
    }
}
