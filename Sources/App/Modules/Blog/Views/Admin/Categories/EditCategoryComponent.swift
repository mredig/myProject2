import Plot

struct EditCategoryComponent: HTMLViewComponent {

	let editingCategory: BlogCategoryEditForm?

	var component: HTMLBodyNode {
		.group([
			.div(
				.class("wrapper"),
				.h2(
					.a(.href("/admin/blog/categories"), "Categories"),
					" / \(editingCategory?.id != nil ? "Edit" : "Create")"
				)
			),
			.form(
				.id("category-edit-form"),
				.class("wrapper"),
				.method(.post),
				.action("/admin/blog/categories/\(editingCategory?.id ?? "new")"),
				.enctype(.multipartData),

				.input(
					.type(.hidden),
					.name("id"),
					.value(editingCategory?.id ?? "")
				),

				.section(
					.label(
						.for("title"),
						"Title ",
						.span(.class("required"), "required")
					),
					.input(
						.id("title"),
						.type(.text),
						.name("title"),
						.value(editingCategory?.title.value ?? ""),
						.class("field")
					),
					.unwrap(editingCategory?.title.error, {
						.span(
							.class("error"),
							.text($0)
						)
					})
				),
				.section(
					.input(
						.type(.submit),
						.class("submit"),
						.value("Save")
					)
				)
			)
		])
	}
}
