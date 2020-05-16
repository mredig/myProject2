//
//  File.swift
//  
//
//  Created by Michael Redig on 5/15/20.
//

import Vapor
import Fluent

struct UserMigration_v1_0_0: Migration {

	private func users() -> [UserModel] {
		let users: [(email: String, pass: String)] = [("he@ho.hum", "Aabc123!")]

		return users.compactMap {
			do {
				let hashedPassword = try Bcrypt.hash($0.pass)
				return UserModel(email: $0.email, password: hashedPassword)
			} catch {
				print("error hashing password: \(error)")
				return nil
			}
		}
	}

	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.eventLoop.flatten([
			database.schema(UserModel.schema)
				.id()
				.field(UserModel.FieldKeys.email, .string, .required)
				.field(UserModel.FieldKeys.password, .string, .required)
				.unique(on: UserModel.FieldKeys.email)
				.create(),
		]).flatMap {
			self.users().create(on: database)
		}
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.eventLoop.flatten([
			database.schema(UserModel.schema).delete()
		])
	}

}

