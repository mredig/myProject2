import Vapor

final class BlogPostEditForm: Encodable {

	struct Input: Decodable {
		var id: String
		var title: String
		var slug: String
		var excerpt: String
		var date: String
		var content: String
		var categoryId: String
		var image: File?
		var imageDelete: Bool?
	}

	var id: String? = nil
	var title = BasicFormField()
	var slug = BasicFormField()
	var excerpt = BasicFormField()
	var date = BasicFormField()
	var content = BasicFormField()
	var categoryId = SelectionFormField()
	var image = FileFormField()

	init() {}

	init(req: Request) throws {
		let context = try req.content.decode(Input.self)
		if !context.id.isEmpty {
			self.id = context.id
		}
		self.title.value = context.title
		self.slug.value = context.slug
		self.excerpt.value = context.excerpt
		self.date.value = context.date
		self.content.value = context.content
		self.categoryId.value = context.categoryId
		self.image.delete = context.imageDelete ?? false

		if let image = context.image,
			let data = image.data.getData(at: 0, length: image.data.readableBytes),
			!data.isEmpty {
			self.image.data = data
		}
	}

	func read(from model: BlogPostModel) {
		id = model.id!.uuidString
		title.value = model.title
		slug.value = model.slug
		excerpt.value = model.excerpt
		date.value = DateFormatter.year.string(from: model.date)
		content.value = model.content
		categoryId.value = model.$category.id.uuidString
		image.value = model.image
	}

	func write(to model: BlogPostModel) {
		model.title = self.title.value
		model.slug = self.slug.value
		model.excerpt = self.excerpt.value
		model.date = DateFormatter.year.date(from: date.value)!
		model.content = self.content.value
		model.$category.id = UUID(uuidString: categoryId.value)!
		if !image.value.isEmpty {
			model.image = image.value
		}
		if image.delete {
			model.image = ""
		}
	}

	func validate(req: Request) -> EventLoopFuture<Bool> {
		var valid = true

		func checkValidity(on formField: inout BasicFormField, fieldName: String) {
			if formField.value.isEmpty {
				valid = false
				formField.error = "\(fieldName) is required."
			}
		}

		checkValidity(on: &title, fieldName: "Title")
		checkValidity(on: &slug, fieldName: "Slug")
		checkValidity(on: &excerpt, fieldName: "Excerpt")
		checkValidity(on: &content, fieldName: "Content")
		if DateFormatter.year.date(from: date.value) == nil {
			date.error = "Invalid date"
			valid = false
		}

		let uuid = UUID(uuidString: categoryId.value)
		return BlogCategoryModel.find(uuid, on: req.db)
			.map { model in
				if model == nil {
					self.categoryId.error = "Category identifier error"
					valid = false
				}
				return valid
			}
	}
}
