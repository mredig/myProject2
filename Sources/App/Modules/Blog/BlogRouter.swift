//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Vapor

struct BlogRouter: RouteCollection {
	let frontendController = BlogFrontendController()
	let adminController = BlogPostAdminController()

	func boot(routes: RoutesBuilder) throws {
		routes.get("blog", use: self.frontendController.blogView)
		routes.get(.anything, use: self.frontendController.postView)

		let protected = routes.grouped([
			UserModelSessionAuthenticator(),
//			UserModel.guardMiddleware(),
			UserModel.redirectMiddleware(path: "/")
		])

		let blog = protected.grouped("admin", "blog")
		let posts = blog.grouped("posts")

		posts.get(use: self.adminController.listView)
		posts.get("new", use: self.adminController.createView)
		posts.post("new", use: self.adminController.create)

	}
}
