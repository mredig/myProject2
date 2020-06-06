import Vapor
import Fluent
import Liquid


struct BlogPostAdminController: ViperAdminViewController {
	typealias EditForm = BlogPostEditForm
	typealias Model = BlogPostModel
	typealias Module = BlogModule

	let editView = "Blog/Admin/Posts/Edit"
	let listView = "Blog/Admin/Posts/List"

	private func generateUniqueAssetLocationKey() -> String {
		Model.path + UUID().uuidString + ".jpg"
	}

	func beforeRender(req: Request, form: BlogPostEditForm) -> EventLoopFuture<Void> {
		BlogCategoryModel.query(on: req.db).all()
			.mapEach(\.formFieldOption)
			.map { form.categoryId.options = $0 }
	}

	func beforeCreate(req: Request, model: BlogPostModel, form: BlogPostEditForm) -> EventLoopFuture<BlogPostModel> {
		var future: EventLoopFuture<BlogPostModel>
		if let data = form.image.data {
			let key = generateUniqueAssetLocationKey()
			future = req.fs.upload(key: key, data: data).map { url in
				form.image.value = url
				model.imageKey = key
				model.image = url
				return model
			}
		} else {
			model.image = ""
			future = req.eventLoop.future(model)
		}
		return future
	}

	func beforeUpdate(req: Request, model: BlogPostModel, form: BlogPostEditForm) -> EventLoopFuture<BlogPostModel> {
		var future = req.eventLoop.future(model)

		if (form.image.delete || form.image.data != nil),
			let imageKey = model.imageKey {
			future = req.fs.delete(key: imageKey).map {
				form.image.value = ""
				model.image = ""
				model.imageKey = nil
				return model
			}
		}
		if let data = form.image.data {
			return future.flatMap { model in
				let key = self.generateUniqueAssetLocationKey()
				return req.fs.upload(key: key, data: data).map { url in
					form.image.value = url
					model.imageKey = key
					model.image = url
					return model
				}
			}
		}
		return future
	}

	func beforeDelete(req: Request, model: BlogPostModel) -> EventLoopFuture<BlogPostModel> {
		if let key = model.imageKey {
			return req.fs.delete(key: key).map { model }
		}
		return req.eventLoop.future(model)
	}
}
