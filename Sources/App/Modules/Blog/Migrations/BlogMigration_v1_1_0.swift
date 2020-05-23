import Fluent

struct BlogMigration_v1_1_0: Migration {

	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.schema(BlogPostModel.schema)
			.field(BlogPostModel.FieldKeys.imageKey, .string)
			.update()
			.flatMap { // move this to the latest migration file
				let defaultCategory = BlogCategoryModel(title: "Uncategorized")
				let islandsCategory = BlogCategoryModel(title: "Islands")
				return [defaultCategory, islandsCategory].create(on: database)
					.flatMap {
						let posts = BlogSeed.uncategorizedPosts(for: defaultCategory) + BlogSeed.islandPosts(for: islandsCategory)
						return posts.create(on: database)
				}
		}
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema(BlogPostModel.schema)
			.deleteField(BlogPostModel.FieldKeys.imageKey)
			.update()
	}

}
