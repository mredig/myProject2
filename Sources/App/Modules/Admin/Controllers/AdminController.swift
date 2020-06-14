//
//  File.swift
//  
//
//  Created by Michael Redig on 5/18/20.
//

import Vapor

struct AdminController {

	func homeView(req: Request) throws -> EventLoopFuture<View> {
		let user = try req.auth.require(UserModel.self)

		let adminHomeComponent = AdminHomeComponent(header: "Hi \(user.email)",
			message: "Welcome to the CMS!")

		let indexView = IndexView.adminIndex(titled: "myPage - Admin", content: adminHomeComponent.component)

		return indexView.futureView(on: req)
	}
}
