import Plot

struct ListCategoriesComponent: HTMLViewComponent {

	let categories: [BlogCategoryModel.ViewContext]

	var component: HTMLBodyNode {
		HTMLBodyNode.group([
			.div(
				.class("wrapper"),
				.a(
					.href("/admin/blog/categories/new"),
					"Create"
				)
			),
			
			.table(
				.class("wrapper"),
				.thead(
					.tr(
						.th("Title"),
						.th(.class("actions"), "Actions")
					)
				),
				.tbody(
					.forEach(categories, { (category: BlogCategoryModel.ViewContext) in
						.tr(
							.td(.text(category.title)),
							.td(
								.class("actions"),
								.a(.href("/admin/blog/categories/\(category.id)"), "Edit"),
								" &middot; ",
								.a(
									.id(category.id),
									.href("#"),
									.onclick("confirmDelete('/admin/blog/categories/', this.id);"),
									"Delete"
								)
							)
						)
					})
				)
			)
		])
	}
}
