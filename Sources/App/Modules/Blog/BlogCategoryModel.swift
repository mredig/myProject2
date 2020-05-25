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
