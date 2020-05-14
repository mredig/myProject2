//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Vapor

struct FrontendRouter: RouteCollection {
	let controller = FrontendController()

	func boot(routes: RoutesBuilder) throws {
		routes.get(use: self.controller.homeView)
	}
}
