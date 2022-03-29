import Vapor
import Fluent

struct UserGamesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let tokenProtected = routes.api.grouped(UserToken.authenticator())
        let userGames = tokenProtected.grouped("users").grouped(":userId").grouped(":games")
        userGames.post(use: create)
        userGames.get(use: getAll)
        userGames.put(":id", use: update)
        userGames.delete(":id", use: delete)
    }
    
    func create(req: Request) throws -> EventLoopFuture<UserGame> {
        let userId = try req.auth.require(User.self).requireID()
        let create = try req.content.decode(UserGame.Create.self)
        let userGame = UserGame(userId: userId,
                                userPlatformId: create.userPlatformId,
                                name: create.name,
                                developer:create.developer)
        return userGame.save(on: req.db).map { userGame }
    }
    
    func getAll(req: Request) throws -> EventLoopFuture<[UserGame]> {
        let user = try req.auth.require(User.self)
        return user.$games.get(on: req.db)
    }
    
    func update(req: Request) throws -> EventLoopFuture<UserGame> {
        let userId = try req.auth.require(User.self).requireID()
        let updatedUserGame = try req.content.decode(UserGame.Create.self)
        return UserGame.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { userGame in
                guard userGame.$user.id == userId else {
                    return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
                }
                userGame.name = updatedUserGame.name
                userGame.developer = updatedUserGame.developer
                userGame.$platform.id = updatedUserGame.userPlatformId
                return userGame.save(on: req.db).map {
                    userGame
                }
            }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let userId = try req.auth.require(User.self).requireID()
        return UserGame.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { userGame in
                guard userGame.$user.id == userId else {
                    return req.eventLoop.makeFailedFuture(Abort(.unauthorized))
                }
                return userGame.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}
