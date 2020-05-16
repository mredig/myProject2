//
//  File.swift
//  
//
//  Created by Michael Redig on 5/15/20.
//

import Vapor

struct UserRouter: RouteCollection {
	let controller = UserFrontendController()

	func boot(routes: RoutesBuilder) throws {
		
	}
}
