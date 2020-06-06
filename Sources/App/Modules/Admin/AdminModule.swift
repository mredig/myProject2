import Vapor
import Fluent
import ViperKit

struct AdminModule: ViperModule {

	static var name = "admin"

	var router: ViperRouter? { AdminRouter() }
}
