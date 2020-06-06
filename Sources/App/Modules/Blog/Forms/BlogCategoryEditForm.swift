import Vapor
import ViewKit

final class BlogCategoryEditForm: Form {
	typealias Model = BlogCategoryModel

	struct Input: Decodable {
		var id: String
		var title: String
	}

	var id: String?
	var title = BasicFormField()

	init() {}

	init(req: Request) throws {
		let context = try req.content.decode(Input.self)
		if !context.id.isEmpty {
			id = context.id
		}
		title.value = context.title
	}

	func write(to model: BlogCategoryModel) {
		model.title = title.value
	}

	func read(from model: BlogCategoryModel) {
		id = model.id!.uuidString
		title.value = model.title
	}

	func validate(req: Request) -> EventLoopFuture<Bool> {
		var valid = true
		if title.value.isEmpty {
			title.error = "Title is required"
			valid = false
		}
		return req.eventLoop.future(valid)
	}
}
