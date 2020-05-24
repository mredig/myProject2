import Vapor
import Fluent

struct BlogCategoryAdminController {

	func listView(req: Request) throws -> EventLoopFuture<View> {
		struct Context<T: Encodable>: Encodable {
			let list: [T]
		}
		return BlogCategoryModel.query(on: req.db)
			.all()
			.mapEach(\.viewContext)
			.flatMap {
				req.view.render("Blog/Admin/Categories/List", Context(list: $0))
			}
	}

	func beforeRender(req: Request, form: BlogCategoryEditForm) -> EventLoopFuture<Void> {
		req.eventLoop.future()
	}

	func render(req: Request, form: BlogCategoryEditForm) -> EventLoopFuture<View> {
		struct Context<T: Encodable>: Encodable {
			let edit: T
		}

		return beforeRender(req: req, form: form).flatMap {
			req.view.render("Blog/Admin/Categories/Edit", Context(edit: form))
		}
	}

	func createView(req: Request) throws -> EventLoopFuture<View> {
		render(req: req, form: .init())
	}

	func beforeCreate(req: Request, model: BlogCategoryModel, form: BlogCategoryEditForm) -> EventLoopFuture<BlogCategoryModel> {
		req.eventLoop.future(model)
	}

	func create(req: Request) throws -> EventLoopFuture<Response> {
		let form = try BlogCategoryEditForm(req: req)

		return form.validate(req: req)
		.flatMap { isValid -> EventLoopFuture<Response> in
			guard isValid else {
				return self.render(req: req, form: form).encodeResponse(for: req)
			}
			let model = BlogCategoryModel()
			form.write(to: model)
			return self.beforeCreate(req: req, model: model, form: form)
			.flatMap { model in
				return model.create(on: req.db)
					.map { req.redirect(to: model.id!.uuidString) }
			}
		}
	}

	func find(req: Request) throws -> EventLoopFuture<BlogCategoryModel> {
		guard let id = req.parameters.get("id"),
			let uuid = UUID(uuidString: id) else {
				throw Abort(.badRequest)
		}
		return BlogCategoryModel
			.find(uuid, on: req.db)
			.unwrap(or: Abort(.notFound))
	}

	func updateView(req: Request) throws -> EventLoopFuture<View> {
		try find(req: req).flatMap { model in
			let form = BlogCategoryEditForm()
			form.read(from: model)
			return self.render(req: req, form: form)
		}
	}

	func beforeUpdate(req: Request, model: BlogCategoryModel, form: BlogCategoryEditForm) -> EventLoopFuture<BlogCategoryModel> {
		req.eventLoop.future(model)
	}

	func update(req: Request) throws -> EventLoopFuture<View> {
		let form = try BlogCategoryEditForm(req: req)

		return form.validate(req: req).flatMap { isValid in
			guard isValid else {
				return self.render(req: req, form: form)
			}
			do {
				return try self.find(req: req)
					.flatMap { model in
						self.beforeUpdate(req: req, model: model, form: form)
					}
					.flatMap { model in
						form.write(to: model)
						return model.update(on: req.db).map {
							form.read(from: model)
						}
					}
					.flatMap {
						self.render(req: req, form: form)
					}
			} catch {
				return req.eventLoop.future(error: error)
			}
		}
	}

	func beforeDelete(req: Request, model: BlogCategoryModel) -> EventLoopFuture<BlogCategoryModel> {
		req.eventLoop.future(model)
	}

	func delete(req: Request) throws -> EventLoopFuture<String> {
		try find(req: req)
			.flatMap { self.beforeDelete(req: req, model: $0) }
			.flatMap { model in
				model.delete(on: req.db).map { model.id!.uuidString }
			}
	}

}
