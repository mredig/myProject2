import Vapor
import Fluent

struct BlogFrontendController {

	let blogFrontendViewController = BlogFrontendViewController()

	func blogView(req: Request) throws -> EventLoopFuture<Response> {
		struct Context: BlogContext {
			struct PostWithCategory: ArticleComponent {
				let slug: String
				let imageSource: String
				let title: String
				let date: String
				let excerpt: String
				let categoryTitle: String
			}
			let title: String
			let posts: [ArticleComponent]
		}
		return BlogPostModel.query(on: req.db)
			.sort(\.$date, .descending)
			.with(\.$category)
			.all()
			.mapEach { Context.PostWithCategory(slug: $0.viewContext.slug,
												imageSource: $0.viewContext.image,
												title: $0.viewContext.title,
												date: $0.viewContext.date,
												excerpt: $0.viewContext.excerpt,
												categoryTitle: $0.category.viewContext.title) }
			.flatMap {
				let context = Context(title: "myPage - Blog", posts: $0)
				return self.blogFrontendViewController
					.blogView(context)
					.encodeResponse(for: req)
		}
	}

	func postView(req: Request) throws -> EventLoopFuture<Response> {
		struct Context: Encodable {
			struct PostWithCategory: Encodable {
				var category: BlogCategoryModel.ViewContext
				var post: BlogPostModel.ViewContext
			}
			let title: String
			let item: PostWithCategory
		}

		let slug = req.url.path.trimmingCharacters(in: .init(charactersIn: "/"))

		return BlogPostModel.query(on: req.db)
			.filter(\.$slug == slug)
			.with(\.$category)
			.first()
			.flatMap { post in
				guard let post = post else {
					return req.eventLoop.future(req.redirect(to: "/"))
				}
				let item = Context.PostWithCategory(category: post.category.viewContext,
													post: post.viewContext)
				let context = Context(title: "myPage - \(post.title)", item: item)
				return req.view.render("Blog/Frontend/Post", context).encodeResponse(for: req)
		}
	}
}
