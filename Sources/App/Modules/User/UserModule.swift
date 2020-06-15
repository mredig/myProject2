import Vapor
import Fluent
import ViperKit

struct UserModule: ViperModule {

	static var name = "user"

	var router: ViperRouter? {
		UserRouter()
	}

	var migrations: [Migration] {
		[
			UserMigration_v1_0_0(),
			UserMigration_v1_1_0(),
//			UserMigration_v1_2_0(),
			UserMigrationSeed(),
		]
	}
}
