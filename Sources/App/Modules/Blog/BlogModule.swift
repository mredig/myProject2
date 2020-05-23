//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Vapor
import Fluent

struct BlogModule: Module {
	var router: RouteCollection? {
		BlogRouter()
	}

	var migrations: [Migration] {
		[
			BlogMigration_v1_0_0(),
			BlogMigration_v1_1_0(),
		]
	}
}
