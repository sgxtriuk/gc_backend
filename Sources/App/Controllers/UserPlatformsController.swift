import Vapor
import Fluent

struct UserPlatformsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.api.grouped(UserToken.authenticator())
        let userPlatforms = tokenProtected.grouped("users").grouped(":userId").grouped("platforms")
        userPlatforms.post(use: create)
        userPlatforms.get(use: getAll)
        userPlatforms.put(":id", use: update)
        userPlatforms.delete(":id", use: delete)
    }
    
    func create(req: Request) throws -> EventLoopFuture<UserPlatform> {
        let userId = try req.auth.require(User.self).requireID()
        let create = try req.content.decode(UserPlatform.Create.self)
        let userPlatform = UserPlatform(name: create.name, userId: userId)
        return userPlatform.save(on: req.db).map { userPlatform }
    }
    
    func getAll(req: Request) throws -> EventLoopFuture<[UserPlatform]> {
        let user = try req.auth.require(User.self)
        return user.$platforms.get(on: req.db)
    }
    
    func update(req: Request) throws -> EventLoopFuture<UserPlatform> {
        let userId = try req.auth.require(User.self).requireID()
        let updatedUserPlatform = try req.content.decode(UserPlatform.Create.self)
        return UserPlatform.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { userPlatform in
                guard userPlatform.$user.id == userId else {
                    return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
                }
                userPlatform.name = updatedUserPlatform.name
                return userPlatform.save(on: req.db).map {
                    userPlatform
                }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let userId = try req.auth.require(User.self).requireID()
        return UserPlatform.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { userPlatform in
                guard userPlatform.$user.id == userId else {
                    return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
                }
                return userPlatform.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}
