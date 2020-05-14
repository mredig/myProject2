//
//  File.swift
//  
//
//  Created by Michael Redig on 5/14/20.
//

import Vapor

struct BlogFrontendController {

	func blogView(req: Request) throws -> EventLoopFuture<View> {
		struct Context: Encodable {
			let title: String
			let posts: [BlogPost]
		}

		let posts = BlogRepository().publishedPosts()
		let context = Context(title: "myPage - Blog", posts: posts)

		return req.view.render("blog", context)
	}
}
