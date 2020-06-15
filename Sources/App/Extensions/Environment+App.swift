import Vapor
import AWSS3


extension Environment {
	static let dbHost = get("DB_HOST") ?? "DB_HOST"
	static let dbUser = get("DB_USER") ?? "DB_USER"
	static let dbPass = get("DB_PASS") ?? "DB_PASS"
	static let dbName = get("DB_NAME") ?? "DB_NAME"

	static let databaseURL: URL? = {
		guard let urlString = get("DATABASE_URL") else { return nil }
		return URL(string: urlString)
	}()

    static let fsName = get("FS_NAME") ?? "FS_NAME"
	static let fsRegion: Region = {
		let envVar = get("FS_REGION")
		return .init(rawValue: envVar ?? "us-west-1")
	}()


	static let appURL: URL = {
		let envVar = get("APP_URL") ?? ""
		return URL(string: envVar) ?? URL(string: "http://localhost")!
	}()
	static let awsKey = get("AWS_KEY") ?? "AWS_KEY"
	static let awsSecret = get("AWS_SECRET") ?? "AWS_SECRET"

	static let siwaId = get("SIWA_ID") ?? "SIWA_ID"
	static let siwaAppId = get("SIWA_APP_ID") ?? "SIWA_APP_ID"
	static let siwaRedirectUrl = get("SIWA_REDIRECT_URL") ?? "SIWA_REDIRECT_URL"
	static let siwaTeamId = get("SIWA_TEAM_ID") ?? "SIWA_TEAM_ID"
	static let siwaJWKId = get("SIWA_JWK_ID") ?? "SIWA_JWK_ID"
	static let siwaKey: String = {
		let envVar = get("SIWA_KEY")
		return envVar?.base64Decoded ?? "SIWA_KEY"
	}()


}
