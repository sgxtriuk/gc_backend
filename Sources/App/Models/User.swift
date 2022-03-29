import Vapor
import Fluent

final class User: Model, Content {
    
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "email")
    var email: String

    @Field(key: "passwordHash")
    var passwordHash: String
    
    @Children(for: \.$user)
    var platforms: [UserPlatform]
    
    @Children(for: \.$user)
    var games: [UserGame]

    init() { }

    init(id: UUID? = nil,
         email: String,
         passwordHash: String) {
        self.id = id
        self.email = email
        self.passwordHash = passwordHash
    }
}

extension User {
    func generateToken() throws -> UserToken {
        try .init(value: [UInt8].random(count: 16).base64,
                  userID: self.requireID())
    }
}

extension User: ModelAuthenticatable {
    static let usernameKey = \User.$email
    static let passwordHashKey = \User.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.passwordHash)
    }
}

extension User {
    struct Create: Content, Validatable {
        var email: String
        var password: String
        var confirmPassword: String
        
        static func validations(_ validations: inout Validations) {
            validations.add("email", as: String.self, is: .email)
            validations.add("password", as: String.self, is: .count(8...64))
        }
    }
}


