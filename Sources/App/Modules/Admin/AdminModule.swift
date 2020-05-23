import Vapor
import Fluent

struct AdminModule: Module {

	static var name = "admin"

	var router: RouteCollection? { AdminRouter() }
}
