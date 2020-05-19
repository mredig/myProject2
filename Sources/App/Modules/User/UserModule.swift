//
//  File.swift
//  
//
//  Created by Michael Redig on 5/15/20.
//

import Vapor
import Fluent

struct UserModule: Module {
	var router: RouteCollection? {
		UserRouter()
	}

	var migrations: [Migration] {
		[UserMigration_v1_0_0(),]
	}
}