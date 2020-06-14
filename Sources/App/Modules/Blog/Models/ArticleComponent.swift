import Plot

protocol ArticleComponent {
	var category: BlogCategoryModel.ViewContext { get }
	var post: BlogPostModel.ViewContext { get }
}
