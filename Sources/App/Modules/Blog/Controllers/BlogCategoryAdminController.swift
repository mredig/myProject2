import Vapor
import Fluent

struct BlogCategoryAdminController: ViperAdminViewController {
	typealias Module = BlogModule
	typealias Model = BlogCategoryModel
	typealias EditForm = BlogCategoryEditForm

	let listView = "Blog/Admin/Categories/List"
	let editView = "Blog/Admin/Categories/Edit"

}
