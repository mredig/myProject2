import Vapor
import Fluent

protocol AdminViewController {
	associatedtype EditForm: Form
	associatedtype Model: Fluent.Model & ViewContextRepresentable

	var idParamKey: String { get }
	var idPathComponent: PathComponent { get }

	var listView: String { get }
	var editView: String { get }

	func listView(req: Request) throws -> EventLoopFuture<View>

	func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void>
	func render(req: Request, form: EditForm) -> EventLoopFuture<View>

	func createView(req: Request) throws -> EventLoopFuture<View>
	func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model>
	func create(req: Request) throws -> EventLoopFuture<Response>

	func find(req: Request) throws -> EventLoopFuture<Model>

	func updateView(req: Request) throws -> EventLoopFuture<View>
	func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model>
	func update(req: Request) throws -> EventLoopFuture<View>

	func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model>
	func delete(req: Request)  throws-> EventLoopFuture<String>
}


extension AdminViewController {
	var idParamKey: String { "id" }
	var idPathComponent: PathComponent { .init(stringLiteral: ":\(idParamKey)")}

	func listView(req: Request) throws -> EventLoopFuture<View> {
		Model.query(on: req.db)
			.all()
			.mapEach(\.viewContext)
			.flatMap { req.view.render(self.listView, ListContext($0)) }
	}

	func beforeRender(req: Request, form: EditForm) -> EventLoopFuture<Void> {
		req.eventLoop.future()
	}

	func render(req: Request, form: EditForm) -> EventLoopFuture<View> {
		return beforeRender(req: req, form: form).flatMap {
			req.view.render(self.editView, EditContext(form))
		}
	}

	func createView(req: Request) throws -> EventLoopFuture<View> {
		render(req: req, form: .init())
	}

	func beforeCreate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
		req.eventLoop.future(model)
	}

	func create(req: Request) throws -> EventLoopFuture<Response> {
		let form = try EditForm(req: req)

		return form.validate(req: req)
		.flatMap { isValid -> EventLoopFuture<Response> in
			guard isValid else {
				return self.render(req: req, form: form).encodeResponse(for: req)
			}
			let model = Model()
			form.write(to: model as! EditForm.Model)
			return self.beforeCreate(req: req, model: model, form: form)
			.flatMap { model in
				return model.create(on: req.db)
					.map { req.redirect(to: model.viewIdentifier) }
			}
		}
	}

	func updateView(req: Request) throws -> EventLoopFuture<View> {
//		try find(req: req).flatMap { model in
//			let form = EditForm()
//			form.read(from: model as! EditForm.Model)
//			return self.render(req: req, form: form)
//		}

		try find(req: req).flatMapFailable { model in
			let form = EditForm()
			let unwrapped = try (model as? EditForm.Model).unwrap()
			form.read(from: unwrapped)
			return self.render(req: req, form: form)
		}
	}

	func beforeUpdate(req: Request, model: Model, form: EditForm) -> EventLoopFuture<Model> {
		req.eventLoop.future(model)
	}

	func update(req: Request) throws -> EventLoopFuture<View> {
		let form = try EditForm(req: req)

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
						form.write(to: model as! EditForm.Model)
						return model.update(on: req.db).map {
							form.read(from: model as! EditForm.Model)
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

	func beforeDelete(req: Request, model: Model) -> EventLoopFuture<Model> {
		req.eventLoop.future(model)
	}

	func delete(req: Request) throws -> EventLoopFuture<String> {
		try find(req: req)
			.flatMap { self.beforeDelete(req: req, model: $0) }
			.flatMap { model in
				model.delete(on: req.db).map { model.viewIdentifier }
			}
	}

}

extension AdminViewController where Model.IDValue == UUID {

	func find(req: Request) throws -> EventLoopFuture<Model> {
		guard let id = req.parameters.get(idParamKey),
			let uuid = UUID(uuidString: id) else {
				throw Abort(.badRequest)
		}
		return Model
			.find(uuid, on: req.db)
			.unwrap(or: Abort(.notFound))
	}

}
