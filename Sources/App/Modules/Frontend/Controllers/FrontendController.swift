import Vapor

struct FrontendController {
	let frontendVC = FrontendViewController()

	func homeView(req: Request) throws -> EventLoopFuture<View> {
		var email: String?
		if let user = req.auth.get(UserModel.self) {
			email = user.email
		}
		struct Context: HomePageContext {
			let title: String
			let header: String
			let message: String
			let email: String?
		}
		let context = Context(title: "myPage - Home",
							  header: "Hi there,",
							  message: "welcome to my awesome pageeeeee!",
							  email: email)

		return frontendVC.homepageView(context).futureView(on: req)
	}
}

