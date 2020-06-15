import Vapor
import Fluent

struct UserMigration_v1_2_0: Migration {
	func prepare(on database: Database) -> EventLoopFuture<Void> {
		database.eventLoop.flatten([
			database.schema(UserModel.schema)
				.field(UserModel.FieldKeys.appleId, .string)
				.update()
//			database.schema(UserModel.schema)
//				.unique(on: UserModel.FieldKeys.appleId)
//				.update(),
		])
	}

	func revert(on database: Database) -> EventLoopFuture<Void> {
		database.schema(UserModel.schema)
			.deleteField(UserModel.FieldKeys.appleId)
			.update()
	}
}

