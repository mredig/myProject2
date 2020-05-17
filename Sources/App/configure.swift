import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
	app.databases.use(.sqlite(.file("db.sqlite")), as: .sqlite)

	app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

	app.views.use(.leaf)
	app.leaf.cache.isEnabled = app.environment.isRelease

	app.sessions.use(.fluent)
	app.migrations.add(SessionRecord.migration)
	app.middleware.use(app.sessions.middleware)

	let modules: [Module] = [
		UserModule(),
		FrontendModule(),
		BlogModule()
	]

	try modules.forEach {
		try $0.configure(app)
	}
}
