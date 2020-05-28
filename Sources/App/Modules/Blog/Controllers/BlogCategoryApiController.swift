import Vapor
import Fluent

struct BlogCategoryApiController: ListContentController, GetContentController {
	typealias Model = BlogCategoryModel
}
