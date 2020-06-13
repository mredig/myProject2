import Plot

struct PostComponent: HTMLViewComponent {

	let article: ArticleComponent

	private func create() -> HTMLBodyComponent {
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

	var component: HTMLBodyComponent {
		create()
	}
}
