import Vapor

struct PlatformsController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let platforms = routes.api.grouped("platforms")
        platforms.post(use: create)
        platforms.get(use: getAll)
        platforms.put(":id", use: update)
        platforms.delete(":id", use: delete)
    }
    
    func create(req: Request) throws -> EventLoopFuture<Platform> {
        let platform = try req.content.decode(Platform.self)
        return platform.save(on: req.db).map { platform }
    }
    
    func getAll(req: Request) throws -> EventLoopFuture<[Platform]> {
        Platform.query(on: req.db).all()
    }
    
    func update(req: Request) throws -> EventLoopFuture<Platform> {
        let updatedPlatform = try req.content.decode(Platform.self)
        return Platform.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { platform in
                platform.name = updatedPlatform.name
                return platform.save(on: req.db).map {
                    platform
                }
            }
    }
    
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Platform.find(req.parameters.get("id"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { platform in
                platform.delete(on: req.db)
                    .transform(to: .noContent)
            }
    }
}
