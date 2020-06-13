import Plot

protocol BlogContext {
	var title: String { get }
	var posts: [ArticleComponent] { get }
}

struct BlogFrontendViewController {

	func blogView(_ context: BlogContext) -> HTML {
		let blogComponent = BlogComponent(articles: context.posts)

		let indexView = IndexView.frontendIndex(titled: context.title, content: blogComponent.component)
		return indexView.view
	}

}
