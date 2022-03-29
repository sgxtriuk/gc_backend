import Vapor

struct GamesController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let games = routes.api.grouped("games")
        games.post(use: create)
        games.get(use: getAll)
        games.put(":id", use: update)
        games.delete(":id", use: delete)
    }
    
    func create(req: Request) throws -> EventLoopFuture<Game> {
        let create = try req.content.decode(Game.Create.self)
        let game = Game(platformId: create.platformId, name: create.name, developer: create.developer)
        return game.save(on: req.db).map { game }
    }
    
    func getAll(req: Request) throws -> EventLoopFuture<[Game]> {
        Game.query(on: req.db).all()
    }
    
    func update(req: Request) throws -> EventLoopFuture<Game> {
        let updatedGame = try req.content.decode(Game.Create.self)
        return Game.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { game in
                game.$platform.id = updatedGame.platformId
                game.name = updatedGame.name
                game.developer = updatedGame.developer
                return game.save(on: req.db).map {
                    game
                }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Game.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { game in
                game.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}
