//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Vapor

struct BlogRouter: RouteCollection {
	let frontendController = BlogFrontendController()
	let postAdminController = BlogPostAdminController()
	let categoryAdminController = BlogCategoryAdminController()

	func boot(routes: RoutesBuilder) throws {
		routes.get("blog", use: self.frontendController.blogView)
		routes.get(.anything, use: self.frontendController.postView)

		let protected = routes.grouped([
			UserModelSessionAuthenticator(),
//			UserModel.guardMiddleware(),
			UserModel.redirectMiddleware(path: "/")
		])

		let blog = protected.grouped("admin", "blog")

		postAdminController.setupRoutes(routes: blog, on: "posts")
		categoryAdminController.setupRoutes(routes: blog, on: "categories")

		let blogApi = routes.grouped("api", "blog")
		let categories = blogApi.grouped("categories")
		let categoryAPIController = BlogCategoryApiController()
		categoryAPIController.setupListRoute(routes: categories)
		categoryAPIController.setupGetRoute(routes: categories)
	}
}
