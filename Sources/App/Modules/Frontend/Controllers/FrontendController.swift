import Vapor

struct FrontendController {

	func homeView(req: Request) throws -> EventLoopFuture<View> {
		var email: String?
		if let user = req.auth.get(UserModel.self) {
			email = user.email
		}

		let homeComponent = HomeComponent(header: "Hi there,",
										  message: "welcome to my awesome page!",
										  email: email)

		let indexView = IndexView.frontendIndex(titled: "myPage - Home",
												content: homeComponent.component)
		return indexView.futureView(on: req)

	}
}

