import Vapor
import Fluent

struct UsersController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let passwordProtected = routes.api.grouped(User.authenticator())
        passwordProtected.post("login", use: login)
        
        let users = routes.api.grouped("users")
        users.post(use: create)
    }
    
    func login(req: Request) throws -> EventLoopFuture<UserToken> {
        let user = try req.auth.require(User.self)
        let token = try user.generateToken()
        return token.save(on: req.db)
            .map { token }
    }
    
    func create(req: Request) throws -> EventLoopFuture<User> {
        try User.Create.validate(content: req)
        let create = try req.content.decode(User.Create.self)
        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Passwords did not match")
        }
        let user = try User(email: create.email,
                            passwordHash: Bcrypt.hash(create.password))
        return user.save(on: req.db)
            .map { user }
    }
}
