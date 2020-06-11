//
//  File.swift
//  
//
//  Created by Michael Redig on 5/15/20.
//

import Vapor
import Fluent

struct UserMigration_v1_0_0: Migration {

	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.eventLoop.flatten([
			database.schema(UserModel.schema)
				.id()
				.field(UserModel.FieldKeys.email, .string, .required)
				.field(UserModel.FieldKeys.password, .string, .required)
				.unique(on: UserModel.FieldKeys.email)
				.create(),
		])
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.eventLoop.flatten([
			database.schema(UserModel.schema).delete()
		])
	}

}

