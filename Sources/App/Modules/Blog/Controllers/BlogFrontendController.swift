import Vapor
import Fluent

struct BlogFrontendController {
	struct PostArticle: ArticleComponent {
		let category: BlogCategoryModel.ViewContext
		let post: BlogPostModel.ViewContext
	}

	func blogView(req: Request) throws -> EventLoopFuture<View> {
		return BlogPostModel.query(on: req.db)
			.sort(\.$date, .descending)
			.with(\.$category)
			.all()
			.mapEach { PostArticle(
				category: $0.category.viewContext,
				post: $0.viewContext)
			}
			.flatMap {
				let blogComponent = BlogComponent(articles: $0)

				let indexView = IndexView.frontendIndex(titled: "myPage - Blog", content: blogComponent.component)
				return indexView.futureView(on: req)
		}
	}

	func postView(req: Request) throws -> EventLoopFuture<Response> {
		let slug = req.url.path.trimmingCharacters(in: .init(charactersIn: "/"))

		return BlogPostModel.query(on: req.db)
			.filter(\.$slug == slug)
			.with(\.$category)
			.first()
			.flatMap { post in
				guard let post = post else {
					return req.eventLoop.future(req.redirect(to: "/"))
				}
				let article = PostArticle(
					category: post.category.viewContext,
					post: post.viewContext)

				let postComponent = PostComponent(article: article)

				let indexView = IndexView.frontendIndex(titled: "myPage - \(post.title)", content: postComponent.component)
				return indexView.view.encodeResponse(for: req)
		}
	}
}
