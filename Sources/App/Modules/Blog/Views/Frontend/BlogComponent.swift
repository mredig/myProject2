import Plot

protocol ArticleComponent {
	var slug: String { get }
	var imageSource: String { get }
	var title: String { get }
	var date: String { get }
	var excerpt: String { get }
	var categoryTitle: String { get }
}

struct BlogComponent: HTMLViewComponent {

	let articles: [ArticleComponent]

	var component: HTMLBodyComponent {
		.section(
			.id("blog"),
			.class("wrapper"),
			.h2("Blog"),

			.group(articles.map {
				HTMLBodyComponent.article(
					.a(
						.href("/\($0.slug)"),
						.img(.src($0.imageSource)),
						.h3(.text($0.title), "(\($0.date))"),
						.p(.text($0.excerpt)),
						.p(.class("category"), .text($0.categoryTitle))
					)
				)
			})

		)
	}
}
