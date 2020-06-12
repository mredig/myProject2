//
//  File.swift
//  
//
//  Created by Michael Redig on 6/12/20.
//

import Plot

enum IndexView {

	static func indexView(titled title: String, content: Node<HTML.BodyContext>) -> HTML {
		return HTML(
			.head(
				.meta(.charset(.utf8)),
				.viewport(.accordingToDevice),
				.title(title),
				.stylesheet("/css/frontend.css"),
				.favicon("/images/favicon.ico")
			),
			.body(
				.header(
					.a(
						.href("/"),
						.img(.src("/images/favicon.ico")),
						.h1(.text(title))
					),
					.nav(
						.id("navigation"),
						.a(.href("/"), "Home"),
						" &middot; ",
						.a(.href("/blog"), "Blog"),
						" &middot; ",
						.a(.href("#"), .onclick("javascript:about();"), "About")
					)
				),
				.main(
					.div(
						.id("content"),
						content
					)
				),
				.script(.src("/javascript/frontend.js"))
			)
		)
	}

}
