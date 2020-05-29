import Vapor
import Fluent

struct BlogCategoryApiController: ListContentController, GetContentController, CreateContentController {
	typealias Model = BlogCategoryModel
}
