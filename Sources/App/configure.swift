import Vapor
import Fluent
import FluentPostgresDriver

public func configure(_ app: Application) throws {
    
    app.databases.use(.postgres(hostname: "localhost",
                                username: "vapor_username",
                                password: "vapor_password",
                                database: "vapor_database"), as: .psql)

    app.migrations.add(CreateUser())
    app.migrations.add(CreateUserToken())
    
    app.migrations.add(CreatePlatform())
    app.migrations.add(CreateGame())
    
    app.migrations.add(CreateUserPlatform())
    app.migrations.add(CreateUserGame())
    
    try app.autoMigrate().wait()
    
    try routes(app)
}
