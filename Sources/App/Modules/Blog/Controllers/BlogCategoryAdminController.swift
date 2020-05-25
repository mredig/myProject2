import Vapor
import Fluent

struct BlogCategoryAdminController: AdminViewController {
	typealias EditForm = BlogCategoryEditForm
	typealias Model = BlogCategoryModel

	let listView = "Blog/Admin/Categories/List"
	let editView = "Blog/Admin/Categories/Edit"

}
