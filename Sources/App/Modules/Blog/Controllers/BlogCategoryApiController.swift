import Vapor
import Fluent

struct BlogCategoryApiController: ListContentController, GetContentController, CreateContentController, UpdateContentController {
	typealias Model = BlogCategoryModel
}
