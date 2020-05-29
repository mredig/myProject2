//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Vapor
import Fluent

final class BlogCategoryModel: Model {
	static let schema = "blog_categories"

	enum FieldKeys {
		static var title: FieldKey { "title" }
	}

	@ID()
	var id: UUID?

	@Field(key: FieldKeys.title)
	var title: String

	@Children(for: \.$category)
	var posts: [BlogPostModel]

	init() {}

	init(id: UUID? = nil, title: String) {
		self.id = id
		self.title = title
	}
}

extension BlogCategoryModel {
	struct ViewContext: Encodable {
		var id: String
		var title: String

		init(model: BlogCategoryModel) {
			self.id = model.id!.uuidString
			self.title = model.title
		}
	}

	var viewContext: ViewContext { .init(model: self) }
}

extension BlogCategoryModel: FormFieldOptionRepresentable {
	var formFieldOption: FormFieldOption {
		.init(key: id!.uuidString, label: title)
	}
}

extension BlogCategoryModel: ViewContextRepresentable {
	var viewIdentifier: String { self.id!.uuidString }
}

extension BlogCategoryModel: ListContentRepresentable {
	struct ListItem: Content {
		var id: String
		var title: String

		init(model: BlogCategoryModel) {
			id = model.id!.uuidString
			title = model.title
		}
	}

	var listContent: ListItem { .init(model: self) }
}

extension BlogCategoryModel: GetContentRepresentable {
	struct GetContent: Content {
		var id: String
		var title: String

		init(model: BlogCategoryModel) {
			id = model.id!.uuidString
			title = model.title
		}
	}

	var getContent: GetContent { .init(model: self) }
}

extension BlogCategoryModel: CreateContentRepresentable {
	struct CreateContent: ValidatableContent {
		var title: String

		static func validations(_ validations: inout Validations) {
			validations.add("title", as: String.self, is: !.empty)
		}
	}

	func create(_ content: CreateContent) throws {
		title = content.title
	}
}
