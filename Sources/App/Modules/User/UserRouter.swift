import Vapor
import ViperKit

struct UserRouter: ViperRouter {
	let controller = UserFrontendController()
	let apiController = UserApiController()

	func boot(routes: RoutesBuilder, app: Application) throws {
		routes.get("sign-in", use: controller.loginView)
		routes.grouped(UserModelCredentialsAuthenticator())
			.post("sign-in", use: controller.login)
		routes.get("logout", use: controller.logout)
		routes.post("siwa-redirect", use: controller.signInWithApple)
		routes.post("redirect", use: controller.signInWithApple)

		let api = routes.grouped("api", "user")
		api.grouped(UserModelCredentialsAuthenticator())
			.post("login", use: apiController.login)
		api.post("sign-in-with-apple", use: apiController.signInWithApple)
	}
}
