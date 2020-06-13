import Vapor
import Fluent

struct BlogCategoryAdminController: ViperAdminViewController {
	typealias Module = BlogModule
	typealias Model = BlogCategoryModel
	typealias EditForm = BlogCategoryEditForm

	let listView = "Blog/Admin/Categories/List"
	let editView = "Blog/Admin/Categories/Edit"


	func render(req: Request, form: BlogCategoryEditForm) -> EventLoopFuture<View> {
		return beforeRender(req: req, form: form).flatMap {
			let title: String
			if !form.title.value.isEmpty {
				title = "Edit: \(form.title.value)"
			} else {
				title = "Create a New Category"
			}
			let indexView = IndexView.adminIndex(titled: title, content: EditCategoryComponent(editingCategory: form).component)
			return req.eventLoop.future(indexView.view.renderedView())
		}
	}

}
