//
//  File.swift
//  
//
//  Created by Michael Redig on 5/15/20.
//

import Vapor
import Fluent

struct UserModelCredentialsAuthenticator: CredentialsAuthenticator {
	struct Input: Content {
		let email: String
		let password: String
	}

	typealias Credentials = Input

	func authenticate(credentials: Credentials,
					  for request: Request) -> EventLoopFuture<Void> {
		UserModel.query(on: request.db)
			.filter(\.$email == credentials.email.lowercased())
		.first()
			.map {
				do {
					if let user = $0,
						try Bcrypt.verify(credentials.password,
										  created: user.password) {
						request.auth.login(user)
					}
				} catch {
					// do nothing
				}
		}

	}
}
