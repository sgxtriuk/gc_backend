import Vapor
import Fluent

final class Game: Model, Content {
    
    static let schema = "games"
    
    @ID
    var id: UUID?
    
    @Parent(key: "platformId")
    var platform: Platform
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "developer")
    var developer: String
    
    init() {}
    
    init(id: UUID? = nil,
         platformId: Platform.IDValue,
         name: String,
         developer: String) {
        self.id = id
        self.$platform.id = platformId
        self.name = name
        self.developer = developer
    }
}

extension Game {
    struct Create: Content {
        var name: String
        var developer: String
        var platformId: UUID
    }
}
