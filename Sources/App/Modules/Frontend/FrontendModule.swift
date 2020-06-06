import Vapor
import Fluent
import ViperKit

struct FrontendModule: ViperModule {

	static var name = "frontend"

	var router: ViperRouter? {
		FrontendRouter()
	}
}
