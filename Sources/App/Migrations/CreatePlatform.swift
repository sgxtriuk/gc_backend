import Fluent

struct CreatePlatform: Migration {
    
    var name: String { "CreatePlatform" }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("platforms")
            .id()
            .field("name", .string, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("platforms").delete()
    }
}
