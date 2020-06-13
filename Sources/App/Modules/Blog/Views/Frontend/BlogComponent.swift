import Plot

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
						.href("/\($0.post.slug)"),
						.img(.src($0.post.image)),
						.h3(.text($0.post.title), "(\($0.post.date))"),
						.p(.text($0.post.excerpt)),
						.p(.class("category"), .text($0.category.title))
					)
				)
			})

		)
	}
}
