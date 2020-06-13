import Plot

struct AdminHomeComponent: HTMLViewComponent {

	let header: String
	let message: String


	var component: HTMLBodyNode {
		.group([
			.section(
				.class("wrapper"),
				.h2(.text(header))
			),
			.section(
				.p(.text(message)),
				.a(.href("/admin/blog/posts"), "Blog posts"),
				" &middot; ",
				.a(.href("/admin/blog/categories"), "Blog categories")
			)
		])
	}
}
