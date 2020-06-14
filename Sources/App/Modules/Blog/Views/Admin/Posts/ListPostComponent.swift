import Plot

struct ListPostComponent: HTMLViewComponent {

	let posts: [BlogPostModel.ViewContext]

	var component: HTMLBodyNode {
		.group([
			.div(
				.class("wrapper"),
				.h2("Posts"),
				.a(.href("/admin/blog/posts/new"), "Create")
			),

			.table(
				.class("wrapper"),
				.thead(
					.tr(
						.th(.class("small"), "Image"),
						.th("Title"),
						.th(.class("actions"), "Actions")
					)
				),
				.tbody(
					.forEach(posts, { (post: BlogPostModel.ViewContext) in
						.tr(
							.td(.class("small"), .img(.src(post.image))),
							.td(.text(post.title)),
							.td(
								.class("actions"),
								.group([
									.a(.href("/admin/blog/posts/\(post.id)"), "Edit"),
									.a(.href("/\(post.slug)"), "Preview"),
									.a(
										.href("#"),
										.id(post.id),
										.onclick("confirmDelete('/admin/blog/posts/',this.id);"),
										"Delete"
									)
									].joined(separatedBy: " &middot; "))
							)
						)
					})
				)
			)
		])
	}

}
