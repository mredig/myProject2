import ContentApi
import MyProjectApi

extension BlogPostListObject: Content {}

extension BlogPostGetObject: Content {}

extension BlogPostUpsertObject: ValidatableContent {}

extension BlogPostPatchObject: ValidatableContent {}

extension BlogPostModel: ApiRepresentable {
	var listContent: BlogPostListObject {
		.init(id: id!,
			  title: title,
			  slug: slug,
			  image: image,
			  excerpt: excerpt,
			  date: date)
	}

	var getContent: BlogPostGetObject {
		.init(id: id!,
			  title: title,
			  slug: slug,
			  image: image,
			  excerpt: excerpt,
			  date: date,
			  content: content)
	}

	private func upsert(_ content: BlogPostUpsertObject) throws {
		title = content.title
		slug = content.slug
		image = content.image
		excerpt = content.excerpt
		date = content.date
		self.content = content.content
	}

	func create(_ content: BlogPostUpsertObject) throws {
		try upsert(content)
	}

	func update(_ content: BlogPostUpsertObject) throws {
		try upsert(content)
	}

	func patch(_ content: BlogPostPatchObject) throws {
		title = content.title ?? title
		slug = content.slug ?? slug
		image = content.image ?? image
		excerpt = content.excerpt ?? excerpt
		date = content.date ?? date
		self.content = content.content ?? self.content
	}
}
