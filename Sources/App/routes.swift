import Vapor

func routes(_ app: Application) throws {
    
    // MARK: - Register Controllers
    
    try app.register(collection: UsersController())
    
    try app.register(collection: PlatformsController())
    try app.register(collection: GamesController())
    
    try app.register(collection: UserPlatformsController())
    try app.register(collection: UserGamesController())
}
