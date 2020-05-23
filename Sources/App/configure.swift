import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver
import Liquid
import LiquidLocalDriver

// configures your application
public func configure(_ app: Application) throws {
	app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

	app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	app.routes.defaultMaxBodySize = "10mb"
	app.fileStorages.use(.local(publicUrl: "http://localhost:8080",
								publicPath: app.directory.publicDirectory,
								workDirectory: "assets"),
						 as: .local)

	app.views.use(.leaf)
	app.leaf.cache.isEnabled = app.environment.isRelease

	let workingDirectory = app.directory.workingDirectory
	app.leaf.configuration.rootDirectory = "/"
	app.leaf.files = ModularViewFiles(workingDirectory: workingDirectory,
									  fileio: app.fileio)

	app.sessions.use(.fluent)
	app.migrations.add(SessionRecord.migration)
	app.middleware.use(app.sessions.middleware)

	let modules: [Module] = [
		UserModule(),
		FrontendModule(),
		AdminModule(),
		BlogModule(),
		UtilityModule(),
	]

	try modules.forEach {
		try $0.configure(app)
	}
}
