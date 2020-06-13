import Plot

struct PostComponent: HTMLViewComponent {

	let article: ArticleComponent

	private func create() -> HTMLBodyNode {
		.section(
			.id("blog"),
			.class("wrapper"),
			.img(.src(article.post.image)),
			.h2("\(article.post.title) (\(article.post.date))"),
			.p(.text(article.post.excerpt)),
			.p(.class("category"), .text(article.category.title)),
			.hr(),
			.p(.text(article.post.content))
		)
	}

	var component: HTMLBodyNode {
		create()
	}
}
