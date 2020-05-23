import Foundation
import Vapor
import Fluent


enum BlogSeed {
	static func uncategorizedPosts(for category: BlogCategoryModel) -> [BlogPostModel] {
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

	static func islandPosts(for category: BlogCategoryModel) -> [BlogPostModel] {
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
}
