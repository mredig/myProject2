import Plot

protocol ArticleComponent {
	var category: BlogCategoryModel.ViewContext { get }
	var post: BlogPostModel.ViewContext { get }
}

protocol BlogContext {
	var title: String { get }
	var posts: [ArticleComponent] { get }
}

protocol PostContext {
	var title: String { get }
	var post: ArticleComponent { get }
}

struct BlogFrontendViewController {

	func blogView(_ context: BlogContext) -> HTML {
		let blogComponent = BlogComponent(articles: context.posts)

		let indexView = IndexView.frontendIndex(titled: context.title, content: blogComponent.component)
		return indexView.view
	}

	func postView(_ context: PostContext) -> HTML {
		let postComponent = PostComponent(article: context.post)

		let indexView = IndexView.frontendIndex(titled: context.title, content: postComponent.component)
		return indexView.view
	}
}
