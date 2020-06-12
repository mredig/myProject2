import Vapor

struct FrontendController {
	func homeView(req: Request) throws -> EventLoopFuture<Response> {
		var email: String?
		if let user = req.auth.get(UserModel.self) {
			email = user.email
		}
		struct Context: Encodable {
			let title: String
			let header: String
			let message: String
			let email: String?
		}
		let context = Context(title: "myPage - Home",
							  header: "Hi there,",
							  message: "welcome to my awesome page!",
							  email: email)

		return IndexView.indexView(
			titled: context.title,
			content: HomeView.homeView(
				header: context.header,
				message:context.message,
				email: context.email)
		).encodeResponse(for: req)
	}
}

