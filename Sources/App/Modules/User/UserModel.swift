//
//  File.swift
//  
//
//  Created by Michael Redig on 5/15/20.
//

import Vapor
import Fluent

fileprivate extension FieldKey {
	static var email: FieldKey { "email" }
}

final class UserModel: Model {

	static let schema: String = "user_users"

	enum FieldKeys {
		static var email: FieldKey { "email" }
		static var password: FieldKey { "password" }
	}

	@ID()
	var id: UUID?

	@Field(key: FieldKeys.email)
	var email: String

	@Field(key: FieldKeys.password)
	var password: String

	init() {}

	init(id: UserModel.IDValue? = nil, email: String, password: String) {
		self.id = id
		self.email = email
		self.password = password
	}
}
