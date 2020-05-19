//
//  File.swift
//  
//
//  Created by Michael Redig on 5/15/20.
//

import Vapor
import Fluent

struct UserFrontendController {
	func loginView(req: Request) throws -> EventLoopFuture<View> {
		struct Context: Encodable {
			let title: String
		}
		let context = Context(title: "myPage - Sign In")
		return req.view.render("User/Frontend/Login", context)
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
}