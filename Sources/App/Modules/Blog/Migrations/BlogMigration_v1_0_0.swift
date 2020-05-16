//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Foundation
import Fluent

struct BlogMigration_v1_0_0: Migration {

	private func uncategorizedPosts(for category: BlogCategoryModel) -> [BlogPostModel] {
		[
			BlogPostModel(title: "California",
						  slug: "california",
						  image: "/images/posts/03.jpg",
						  excerpt: "Voluptates ipsa eos sit distinctio.",
						  date: DateFormatter.year.date(from: "2015")!,
						  content: "Et non reiciendis et illum corrupti. Et ducimus optio commodi molestiae quis ipsum consequatur. A fugit amet amet qui tenetur. Aut voluptates ut labore consectetur temporibus consectetur. Perferendis et neque id minima voluptatem temporibus a dolor. Eos nihil dignissimos consequuntur et consequuntur nam.",
						  categoryId: category.id!)
		]
	}

	private func islandPosts(for category: BlogCategoryModel) -> [BlogPostModel] {
		[
			BlogPostModel(title: "Indonesia",
						  slug: "indonesia",
						  image: "/images/posts/05.jpg",
						  excerpt: "Voluptates ipsa eos sit distinctio.",
						  date: DateFormatter.year.date(from: "2019")!,
						  content: "Et non reiciendis et illum corrupti. Et ducimus optio commodi molestiae quis ipsum consequatur. A fugit amet amet qui tenetur. Aut voluptates ut labore consectetur temporibus consectetur. Perferendis et neque id minima voluptatem temporibus a dolor. Eos nihil dignissimos consequuntur et consequuntur nam.",
						  categoryId: category.id!),
			BlogPostModel(title: "Mauritius",
						  slug: "mauritius",
						  image: "/images/posts/04.jpg",
						  excerpt: "Voluptates ipsa eos sit distinctio.",
						  date: DateFormatter.year.date(from: "2016")!,
						  content: "Et non reiciendis et illum corrupti. Et ducimus optio commodi molestiae quis ipsum consequatur. A fugit amet amet qui tenetur. Aut voluptates ut labore consectetur temporibus consectetur. Perferendis et neque id minima voluptatem temporibus a dolor. Eos nihil dignissimos consequuntur et consequuntur nam.",
						  categoryId: category.id!),
			BlogPostModel(title: "The Maldives",
						  slug: "the-maldives",
						  image: "/images/posts/02.jpg",
						  excerpt: "Voluptates ipsa eos sit distinctio.",
						  date: DateFormatter.year.date(from: "2014")!,
						  content: "Et non reiciendis et illum corrupti. Et ducimus optio commodi molestiae quis ipsum consequatur. A fugit amet amet qui tenetur. Aut voluptates ut labore consectetur temporibus consectetur. Perferendis et neque id minima voluptatem temporibus a dolor. Eos nihil dignissimos consequuntur et consequuntur nam.",
						  categoryId: category.id!),
			BlogPostModel(title: "Sri Lanka",
						  slug: "sri-lanka",
						  image: "/images/posts/01.jpg",
						  excerpt: "Voluptates ipsa eos sit distinctio.",
						  date: DateFormatter.year.date(from: "2014")!,
						  content: "Et non reiciendis et illum corrupti. Et ducimus optio commodi molestiae quis ipsum consequatur. A fugit amet amet qui tenetur. Aut voluptates ut labore consectetur temporibus consectetur. Perferendis et neque id minima voluptatem temporibus a dolor. Eos nihil dignissimos consequuntur et consequuntur nam.",
						  categoryId: category.id!),
		]
	}

	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.eventLoop.flatten([
			database.schema(BlogCategoryModel.schema)
				.id()
				.field(BlogCategoryModel.FieldKeys.title, .string, .required)
				.create(),
			database.schema(BlogPostModel.schema)
				.id()
				.field(BlogPostModel.FieldKeys.title, .string, .required)
			.field(BlogPostModel.FieldKeys.slug, .string, .required)
			.field(BlogPostModel.FieldKeys.image, .string, .required)
			.field(BlogPostModel.FieldKeys.excerpt, .string, .required)
			.field(BlogPostModel.FieldKeys.date, .datetime, .required)
			.field(BlogPostModel.FieldKeys.content, .string, .required)
			.field(BlogPostModel.FieldKeys.categoryId, .uuid)
				.foreignKey(BlogPostModel.FieldKeys.categoryId,
							references: BlogCategoryModel.schema, .id,
							onDelete: DatabaseSchema.ForeignKeyAction.setNull,
							onUpdate: .cascade)
				.unique(on: BlogPostModel.FieldKeys.slug)
				.create(),
		])
			.flatMap {
				let defaultCategory = BlogCategoryModel(title: "Uncategorized")
				let islandsCategory = BlogCategoryModel(title: "Islands")
				return [defaultCategory, islandsCategory].create(on: database)
					.flatMap { [unowned defaultCategory] in
						let posts = self.uncategorizedPosts(for: defaultCategory) + self.islandPosts(for: islandsCategory)
						return posts.create(on: database)
				}
		}
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.eventLoop.flatten([
			database.schema(BlogCategoryModel.schema).delete(),
			database.schema(BlogPostModel.schema).delete()
		])
	}

}
