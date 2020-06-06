import Vapor
import Leaf
import Fluent
//import FluentSQLiteDriver
import FluentPostgresDriver
import Liquid
import LiquidLocalDriver
//import LiquidAwsS3Driver
import ViperKit
import AWSS3

extension Environment {
	static let pgURL = URL(string: Self.get("DB_URL")!)!
	static let appURL = URL(string: Self.get("APP_URL")!)!
	static let awsKey = Self.get("AWS_KEY")!
	static let awsSecret = Self.get("AWS_SECRET")!
}

// configures your application
public func configure(_ app: Application) throws {
//	app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)
	try app.databases.use(.postgres(url: Environment.pgURL), as: .psql)

	app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	app.routes.defaultMaxBodySize = "10mb"
	app.fileStorages.use(.local(publicUrl: Environment.appURL.absoluteString,
								publicPath: app.directory.publicDirectory,
								workDirectory: "assets"),
						 as: .local)
//	app.fileStorages.use(.awsS3(key: Environment.awsKey,
//								secret: Environment.awsSecret,
//								bucket: "demoproject",
//								region: .useast1,
//								endpoint: "https://s3.us-west-1.wasabisys.com"),
//						 as: .awsS3)

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

//	try modules.forEach {
//		try $0.configure(app)
//	}
	try app.viper.use(modules)
}
