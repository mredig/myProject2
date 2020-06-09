import Vapor
import Fluent
import ContentApi
import MyProjectApi

struct BlogPostApiController: ApiController {
	typealias Model = BlogPostModel

	func setValidCategory(req: Request, model: Model, categoryId: String) -> EventLoopFuture<Model> {
		guard let uuid = UUID(uuidString: categoryId) else {
			return req.eventLoop.future(error: Abort(.badRequest))
		}
		return BlogCategoryModel.find(uuid, on: req.db)
			.unwrap(or: Abort(.badRequest))
			.map { category in
				model.$category.id = category.id!
				return model
			}
	}

	func beforeCreate(req: Request, model: BlogPostModel, content: BlogPostUpsertObject) -> EventLoopFuture<BlogPostModel> {
		setValidCategory(req: req, model: model, categoryId: content.categoryId)
	}

	func beforeUpdate(req: Request, model: BlogPostModel, content: BlogPostUpsertObject) -> EventLoopFuture<BlogPostModel> {
		setValidCategory(req: req, model: model, categoryId: content.categoryId)
	}
}
