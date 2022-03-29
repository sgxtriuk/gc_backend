import Fluent

struct CreateUserToken: Migration {
    
    var name: String { "CreateUserToken" }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userTokens")
            .id()
            .field("value", .string, .required)
            .field("userId", .uuid, .required, .references("users", "id"))
            .unique(on: "value")
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("userTokens").delete()
    }
}
