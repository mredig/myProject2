import Vapor
import Fluent

struct BlogCategoryApiController: ListContentController, GetContentController, CreateContentController, UpdateContentController, PatchContentController {
	typealias Model = BlogCategoryModel
}
