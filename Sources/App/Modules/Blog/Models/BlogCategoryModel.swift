import Vapor
import Fluent
import ViewKit
import ContentApi
import ViperKit

final class BlogCategoryModel: ViperModel {
	typealias Module = BlogModule

	static var name: String = "categories"
	static let schema = "blog_categories"

	enum FieldKeys {
		static var title: FieldKey { "title" }
	}

	@ID()
	var id: UUID?

	@Field(key: FieldKeys.title)
	var title: String

	@Children(for: \.$category)
	var posts: [BlogPostModel]

	init() {}

	init(id: UUID? = nil, title: String) {
		self.id = id
		self.title = title
	}
}
