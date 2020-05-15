//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Vapor
import Fluent

struct FrontendModule: Module {
	var router: RouteCollection? {
		FrontendRouter()
	}
}
