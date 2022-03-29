import Vapor

extension RoutesBuilder {
    var api: RoutesBuilder { grouped("api") }
}
