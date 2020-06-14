import Vapor
import Fluent

struct BlogCategoryAdminController: ViperAdminViewController {
	typealias Module = BlogModule
	typealias Model = BlogCategoryModel
	typealias EditForm = BlogCategoryEditForm

	func listView(req: Request) throws -> EventLoopFuture<View> {
		return BlogCategoryModel.query(on: req.db)
			.all()
			.mapEach(\.viewContext)
			.flatMap {
				let listComponent = ListCategoriesComponent(categories: $0)

				let indexView = IndexView.adminIndex(titled: "mySite", content: listComponent.component)
				return indexView.futureView(on: req)
			}
	}

	func render(req: Request, form: BlogCategoryEditForm) -> EventLoopFuture<View> {
		return beforeRender(req: req, form: form).flatMap {
			let title: String
			if !form.title.value.isEmpty {
				title = "Edit: \(form.title.value)"
			} else {
				title = "Create a New Category"
			}
			let editComponent = EditCategoryComponent(editingCategory: form)

			let indexView = IndexView.adminIndex(titled: title, content: editComponent.component)
			return indexView.futureView(on: req)
		}
	}

}
