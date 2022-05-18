import Fluent
import Vapor

final class User: Model, Content {
    // Name of the table or collection.
    static let schema = "users"

    // Unique identifier for this User.
    @ID(key: .id)
    var id: UUID?

    // The User's firstname.
    @Field(key: "firstname")
    var firstname: String
    
    // The User's surname.
    @Field(key: "surname")
    var surname: String

    // Creates a new, empty User.
    init() { }

    // Creates a new User with all properties set.
    init(id: UUID? = nil, firstname: String, surname: String) {
        self.id = id
        self.firstname = firstname
        self.surname = surname
    }
}

struct CreateUser: AsyncMigration {
    // Prepares the database for storing User models.
    func prepare(on database: Database) async throws {
        try await database.schema("users")
            .id()
            .field("firstname", .string)
            .field("surname", .string)
            .create()
    }

    // Optionally reverts the changes made in the prepare method.
    func revert(on database: Database) async throws {
        try await database.schema("users").delete()
    }
}