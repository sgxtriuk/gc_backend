import Fluent

struct CreateUserPlatform: Migration {
    
    var name: String { "CreateUserPlatform" }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userPlatforms")
            .id()
            .field("userId", .uuid, .required, .references("users", "id"))
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userPlatforms").delete()
    }
}
