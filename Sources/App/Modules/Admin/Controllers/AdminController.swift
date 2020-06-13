//
//  File.swift
//  
//
//  Created by Michael Redig on 5/18/20.
//

import Vapor

struct AdminController {

	let adminUserViewController = AdminUserViewController()

	func homeView(req: Request) throws -> EventLoopFuture<Response> {
		let user = try req.auth.require(UserModel.self)

		struct Context: AdminHomeContext {
			let title: String
			let header: String
			let message: String
		}

		let context = Context(title: "myPage - Admin",
							  header: "Hi \(user.email)",
							  message: "Welcome to the CMS!")
		return adminUserViewController.adminHomeView(context).encodeResponse(for: req)
	}
}
