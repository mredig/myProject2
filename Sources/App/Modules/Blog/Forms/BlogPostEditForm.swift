import Vapor

final class BlogPostEditForm: Encodable {

	struct Input: Decodable {
		var id: String
		var title: String
		var slug: String
		var excerpt: String
		var date: String
		var content: String
	}

	var id: String? = nil
	var title = BasicFormField()
	var slug = BasicFormField()
	var excerpt = BasicFormField()
	var date = BasicFormField()
	var content = BasicFormField()

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
	}

	func write(to model: BlogPostModel) {
		model.title = self.title.value
		model.slug = self.slug.value
		model.excerpt = self.excerpt.value
		model.date = DateFormatter.year.date(from: self.date.value)!
		model.content = self.content.value
	}

	func validate() -> Bool {
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
		return valid
	}
}
