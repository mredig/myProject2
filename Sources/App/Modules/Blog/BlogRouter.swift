import Vapor
import ViperKit

struct BlogRouter: ViperRouter {
	let frontendController = BlogFrontendController()
	let postAdminController = BlogPostAdminController()
	let categoryAdminController = BlogCategoryAdminController()

	func boot(routes: RoutesBuilder, app: Application) throws {
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

		let blogApi = routes.grouped([
			UserTokenModel.authenticator(),
			UserModel.guardMiddleware()
		]).grouped("api", "blog")
		let categories = blogApi.grouped("categories")
		let categoryAPIController = BlogCategoryApiController()
		categoryAPIController.setupListRoute(routes: categories)
		categoryAPIController.setupGetRoute(routes: categories)
		categoryAPIController.setupCreateRoute(routes: categories)
		categoryAPIController.setupUpdateRoute(routes: categories)
		categoryAPIController.setupPatchRoute(routes: categories)
		categoryAPIController.setupDeleteRoute(routes: categories)

		let postsApiController = BlogPostApiController()
		postsApiController.setupRoutes(routes: blogApi, on: "posts")
	}
}
