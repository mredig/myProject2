import Vapor
import Fluent

struct UserFrontendController {

	func loginView(req: Request) throws -> EventLoopFuture<View> {
		let state = [UInt8].random(count: 16).base64
		req.session.data["state"] = state

		let loginComponent = LoginComponent(siwaClientId: Environment.siwaId,
											siwaScope: "name email",
											siwaRedirectUrl: Environment.siwaRedirectUrl,
											siwaState: state,
											siwaPopup: false)

		let indexView = IndexView.frontendIndex(titled: "myPage - Sign In",
												content: loginComponent.component)

		return indexView.futureView(on: req)
	}

	func login(req: Request) throws -> Response {
		guard let user = req.auth.get(UserModel.self) else {
			throw Abort(.unauthorized)
		}
		req.session.authenticate(user)
		return req.redirect(to: "/")
	}

	func logout(req: Request) throws -> Response {
		req.auth.logout(UserModel.self)
		req.session.unauthenticate(UserModel.self)
		return req.redirect(to: "/")
	}

	func signInWithApple(req: Request) throws -> EventLoopFuture<Response> {
		struct AuthResponse: Decodable {
			enum CodingKeys: String, CodingKey {
				case code
				case state
				case idToken = "id_token"
				case user
			}
			let code: String
			let state: String
			let idToken: String
			let user: String
		}

		let state = req.session.data["state"] ?? ""
		let auth = try req.content.decode(AuthResponse.self)
		guard !state.isEmpty, state == auth.state else {
			throw Abort(.badRequest)
		}

		return UserModel.siwa(req: req, idToken: auth.idToken, appId: Environment.siwaId)
			.map { user -> Response in
				req.session.authenticate(user)
				return req.redirect(to: "/")
		}
	}
}
