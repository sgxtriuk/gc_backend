import Fluent

struct CreateUserGame: Migration {
    
    var name: String { "CreateUserGame" }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userGames")
            .id()
            .field("userId", .uuid, .required, .references("users", "id"))
            .field("userPlatformId", .uuid, .required, .references("userPlatforms", "id"))
            .field("name", .string, .required)
            .field("developer", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userGames").delete()
    }
}
