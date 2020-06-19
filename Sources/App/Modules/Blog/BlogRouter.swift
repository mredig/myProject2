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
			UserModel.redirectMiddleware(path: "/")
		])

		let blog = protected.grouped("admin", "blog")

		postAdminController.setupRoutes(routes: blog, on: "posts")
		categoryAdminController.setupRoutes(routes: blog, on: "categories")

		let publicApi = routes.grouped("api", "blog")
		let privateApi = publicApi.grouped([
			UserTokenModel.authenticator(),
			UserModel.guardMiddleware()
		])
		let publicCategories = publicApi.grouped("categories")
		let privateCategories = privateApi.grouped("categories")
		let categoryAPIController = BlogCategoryApiController()
		categoryAPIController.setupListRoute(routes: publicCategories)
		categoryAPIController.setupGetRoute(routes: publicCategories)

		categoryAPIController.setupCreateRoute(routes: privateCategories)
		categoryAPIController.setupUpdateRoute(routes: privateCategories)
		categoryAPIController.setupPatchRoute(routes: privateCategories)
		categoryAPIController.setupDeleteRoute(routes: privateCategories)

		let publicPosts = publicApi.grouped("posts")
		let privatePosts = privateApi.grouped("posts")
		let postsApiController = BlogPostApiController()
		postsApiController.setupListRoute(routes: publicPosts)
		postsApiController.setupGetRoute(routes: publicPosts)

		postsApiController.setupCreateRoute(routes: privatePosts)
		postsApiController.setupUpdateRoute(routes: privatePosts)
		postsApiController.setupPatchRoute(routes: privatePosts)
		postsApiController.setupDeleteRoute(routes: privatePosts)
	}
}
