import Vapor
import Fluent

final class UserPlatform: Model, Content {
    
    static let schema = "userPlatforms"
    
    @ID
    var id: UUID?
    
    @Parent(key: "userId")
    var user: User
    
    @Field(key: "name")
    var name: String
    
    init() {}
    
    init(id: UUID? = nil,
         name: String,
         userId: User.IDValue) {
        self.id = id
        self.name = name
        self.$user.id = userId
    }
}

extension UserPlatform {
    struct Create: Content {
        var name: String
    }
}

