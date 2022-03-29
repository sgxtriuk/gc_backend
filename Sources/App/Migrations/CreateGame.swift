import Fluent

struct CreateGame: Migration {
    
    var name: String { "CreateGame" }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("games")
            .id()
            .field("platformId", .uuid, .required, .references("platforms", "id"))
            .field("name", .string, .required)
            .field("developer", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("games").delete()
    }
}
