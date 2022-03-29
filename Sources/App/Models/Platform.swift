import Vapor
import Fluent

final class Platform: Model, Content {
    
    static let schema = "platforms"
    
    @ID
    var id: UUID?
    
    @Children(for: \.$platform)
    var games: [Game]
    
    @Field(key: "name")
    var name: String
    
    init() {}
    
    init(id: UUID? = nil, name: String) {
        self.id = id
        self.name = name
    }
}
