import Vapor
import Leaf
import Fluent
import FluentPostgresDriver
import Liquid
import LiquidAwsS3Driver
import ViperKit
import AWSS3

extension Environment {
	static let dbHost = Self.get("DB_HOST") ?? "DB_HOST"
	static let dbUser = Self.get("DB_USER") ?? "DB_USER"
	static let dbPass = Self.get("DB_PASS") ?? "DB_PASS"
	static let dbName = Self.get("DB_NAME") ?? "DB_NAME"

    static let fsName = Self.get("FS_NAME") ?? "FS_NAME"
    static let fsRegion = Region(rawValue: Self.get("FS_REGION") ?? "us-west-1")

	static let pgURL = URL(string: Self.get("DB_URL") ?? "http://localhost")!
	static let appURL = URL(string: Self.get("APP_URL") ?? "http://localhost")!
	static let awsKey = Self.get("AWS_KEY") ?? "AWS_KEY"
	static let awsSecret = Self.get("AWS_SECRET") ?? "AWS_SECRET"
}

// configures your application
public func configure(_ app: Application) throws {
	let postgresConfig = PostgresConfiguration(hostname: Environment.dbHost,
											   port: 5432,
											   username: Environment.dbUser,
											   password: Environment.dbPass,
											   database: Environment.dbName)

	app.databases.use(.postgres(configuration: postgresConfig), as: .psql)

	app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	app.routes.defaultMaxBodySize = "10mb"
	app.fileStorages.use(.awsS3(key: Environment.awsKey,
								secret: Environment.awsSecret,
								bucket: Environment.fsName,
								region: Environment.fsRegion),
						 as: .awsS3)

	app.views.use(.leaf)
//	app.leaf.cache.isEnabled = app.environment.isRelease
	if app.environment.isRelease {
		app.leaf.cache.isEnabled = false
		app.leaf.useViperViews()
	}

	let workingDirectory = app.directory.workingDirectory
	app.leaf.configuration.rootDirectory = "/"
	app.leaf.files = ModularViewFiles(workingDirectory: workingDirectory,
									  fileio: app.fileio)

	app.sessions.use(.fluent)
	app.migrations.add(SessionRecord.migration)
	app.middleware.use(app.sessions.middleware)

	let modules: [ViperModule] = [
		UserModule(),
		FrontendModule(),
		AdminModule(),
		BlogModule(),
		UtilityModule(),
	]

	try app.viper.use(modules)

	let triesLeft: UInt32 = 5

	// only migrate here if we are not testing
	guard app.environment != .testing else { return }
	// try a few times, incrementing delay between when failing. This is to give the DB time to start up.
	for tryCount in 1...triesLeft {
		do {
			print("attempting database connection: \(tryCount)")
			try app.autoMigrate().wait()
			break
		} catch {
			print("Error trying to migrate database: \(error)")
			let waitSeconds = tryCount * 3
			print("waiting \(waitSeconds) seconds before trying again")
			sleep(waitSeconds)
		}
	}
}
