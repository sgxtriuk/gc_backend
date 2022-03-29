import Vapor
import Fluent

final class UserGame: Model, Content {
    
    static let schema = "userGames"
    
    @ID
    var id: UUID?
    
    @Parent(key: "userId")
    var user: User
    
    @Parent(key: "userPlatformId")
    var platform: UserPlatform
    
    @Field(key: "name")
    var name: String
    
    @Field(key: "developer")
    var developer: String
    
    init() {}
    
    init(id: UUID? = nil,
         userId: User.IDValue,
         userPlatformId: UserPlatform.IDValue,
         name: String,
         developer: String) {
        self.id = id
        self.$user.id = userId
        self.$platform.id = userPlatformId
        self.name = name
        self.developer = developer
    }
}

extension UserGame {
    struct Create: Content {
        var name: String
        var developer: String
        var userPlatformId: UUID
    }
}

