import Vapor
import Fluent
import ViewKit
import ContentApi
import ViperKit

final class BlogPostModel: ViperModel {
	typealias Module = BlogModule

	static var name: String = "posts"

	static let schema: String = "blog_posts"

	enum FieldKeys {
		static var title: FieldKey { "title" }
		static var slug: FieldKey { "slug" }
		static var image: FieldKey { "image" }
		static var imageKey: FieldKey { "image_key" }
		static var excerpt: FieldKey { "excerpt" }
		static var date: FieldKey { "date" }
		static var content: FieldKey { "content" }
		static var categoryId: FieldKey { "category_id" }
	}

	@ID()
	var id: UUID?

	@Field(key: FieldKeys.title)
	var title: String

	@Field(key: FieldKeys.slug)
	var slug: String

	@Field(key: FieldKeys.image)
	var image: String

	@Field(key: FieldKeys.imageKey)
	var imageKey: String?

	@Field(key: FieldKeys.excerpt)
	var excerpt: String

	@Field(key: FieldKeys.date)
	var date: Date

	@Field(key: FieldKeys.content)
	var content: String

	@Parent(key: FieldKeys.categoryId)
	var category: BlogCategoryModel

	init() {}

	init(id: UUID? = nil,
		title: String,
		slug: String,
		image: String,
		imageKey: String? = nil,
		excerpt: String,
		date: Date,
		content: String,
		categoryId: UUID)
	{
		self.id = id
		self.title = title
		self.slug = slug
		self.image = image
		self.imageKey = imageKey
		self.excerpt = excerpt
		self.date = date
		self.content = content
		self.$category.id = categoryId
	}

}

extension BlogPostModel: ViewContextRepresentable {
	struct ViewContext: Encodable {
		var id: String
		var title: String
		var slug: String
		var image: String
		var excerpt: String
		var date: String
		var content: String

		init(model: BlogPostModel) {
			self.id = model.id!.uuidString
			self.title = model.title
			self.slug = model.slug
			self.image = model.image
			self.excerpt = model.excerpt
			self.date = DateFormatter.year.string(from: model.date)
			self.content = model.content
		}
	}

	var viewContext: ViewContext { .init(model: self) }
}

extension BlogPostModel: ApiRepresentable {
	struct ListItem: Content {
		var id: UUID
		var title: String
		var slug: String
		var image: String
		var excerpt: String
		var date: Date
	}

	struct CreateUpdateContent: ValidatableContent {
		var title: String
		var slug: String
		var image: String
		var excerpt: String
		var date: Date
		var content: String

//		static func validations(_ validations: inout Validations) {
//			validations.add("title", as: String.self, is: !.empty)
//			validations.add("slug", as: String.self, is: !.empty)
//			validations.add("image", as: String.self, is: !.empty)
//			validations.add("date", as: Date.self, is: .valid)
//			validations.add("content", as: String.self, is: !.empty)
//		}
	}

	struct PatchContent: ValidatableContent {
		var title: String?
		var slug: String?
		var image: String?
		var excerpt: String?
		var date: Date?
		var content: String?
	}

	struct GetContent: Content {
		var id: UUID
		var title: String
		var slug: String
		var image: String
		var excerpt: String
		var date: Date
		var content: String
	}

	var listContent: ListItem {
		.init(id: id!,
			  title: title,
			  slug: slug,
			  image: image,
			  excerpt: excerpt,
			  date: date)
	}

	var getContent: GetContent {
		.init(id: id!,
			  title: title,
			  slug: slug,
			  image: image,
			  excerpt: excerpt,
			  date: date,
			  content: content)
	}

	private func createOrUpdate(_ content: CreateUpdateContent) throws {
		title = content.title
		slug = content.slug
		image = content.image
		excerpt = content.excerpt
		date = content.date
		self.content = content.content
	}

	func create(_ content: CreateUpdateContent) throws {
		try createOrUpdate(content)
	}

	func update(_ content: CreateUpdateContent) throws {
		try createOrUpdate(content)
	}

	func patch(_ content: PatchContent) throws {
		title = content.title ?? title
		slug = content.slug ?? slug
		image = content.image ?? image
		excerpt = content.excerpt ?? excerpt
		date = content.date ?? date
		self.content = content.content ?? self.content
	}
}
