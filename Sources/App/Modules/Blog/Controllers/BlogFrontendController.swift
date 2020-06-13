import Vapor
import Fluent

struct BlogFrontendController {

	let blogFrontendViewController = BlogFrontendViewController()

	func blogView(req: Request) throws -> EventLoopFuture<Response> {
		struct Context: BlogContext {
			struct PostWithCategory: ArticleComponent {
				let category: BlogCategoryModel.ViewContext
				let post: BlogPostModel.ViewContext
			}
			let title: String
			let posts: [ArticleComponent]
		}
		return BlogPostModel.query(on: req.db)
			.sort(\.$date, .descending)
			.with(\.$category)
			.all()
			.mapEach { Context.PostWithCategory(
				category: $0.category.viewContext,
				post: $0.viewContext)
			}
			.flatMap {
				let context = Context(title: "myPage - Blog", posts: $0)
				return self.blogFrontendViewController
					.blogView(context)
					.encodeResponse(for: req)
		}
	}

	func postView(req: Request) throws -> EventLoopFuture<Response> {
		struct Context: PostContext {
			struct PostWithCategory: ArticleComponent {
				var category: BlogCategoryModel.ViewContext
				var post: BlogPostModel.ViewContext
			}
			let title: String
			let post: ArticleComponent
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
				let context = Context(title: "myPage - \(post.title)", post: item)
				return self.blogFrontendViewController.postView(context).encodeResponse(for: req)
		}
	}
}
