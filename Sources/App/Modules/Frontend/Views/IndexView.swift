import Plot
import Vapor

struct IndexView: HTMLView {
	let title: String
	let content: HTMLBodyNode
	let allowRobots: Bool
	let styleSheets: HTMLHeadNode
	let navigation: HTMLBodyNode
	let mainContentID: String
	let pageScripts: HTMLBodyNode

	static var normalNav: [HTMLBodyNode] = [
		.a(.href("/"), "Home"),
		.a(.href("/blog"), "Blog"),
		.a(.href("#"), .onclick("javascript:about();"), "About")
	]

	static var adminNav: [HTMLBodyNode] = [
		.a(.href("/"), "Home"),
		.a(.href("/admin"), "Admin"),
		.a(.href("/logout"), "Logout")
	]

	private init(title: String,
				 content: HTMLBodyNode,
				 allowRobots: Bool = false,
				 styleSheets: [String],
				 navigationAnchorArray: [HTMLBodyNode],
				 mainContentID: String,
				 pageScripts: [String]) {
		self.title = title
		self.content = content
		self.allowRobots = allowRobots

		let sheets = styleSheets.map { HTMLHeadNode.stylesheet($0) }
		self.styleSheets = .group(sheets)

		self.navigation = .nav(
			.id("navigation"),
			.group(navigationAnchorArray.joined(separatedBy: HTMLBodyNode.text(" &middot; ")))
		)

		self.mainContentID = mainContentID

		let scripts = pageScripts.map { HTMLBodyNode.script(.src($0)) }
		self.pageScripts = .group(scripts)
	}

	static func frontendIndex(titled title: String, content: HTMLBodyNode, navigationAnchorArray: [HTMLBodyNode] = normalNav) -> Self {
		IndexView(title: title,
				  content: content,
				  allowRobots: true,
				  styleSheets: ["/css/frontend.css"],
				  navigationAnchorArray: navigationAnchorArray,
				  mainContentID: "content",
				  pageScripts: ["/javascript/frontend.js"])
	}

	static func adminIndex(titled title: String, content: HTMLBodyNode, navigationAnchorArray: [HTMLBodyNode] = adminNav) -> Self {
		IndexView(title: title,
				  content: content,
				  allowRobots: false,
				  styleSheets: ["/css/frontend.css", "/css/admin.css"],
				  navigationAnchorArray: navigationAnchorArray,
				  mainContentID: "main-content",
				  pageScripts: ["/javascript/admin.js"])
	}

	var html: HTML {
		HTML(
			.head(
				.meta(.charset(.utf8)),
				.viewport(.accordingToDevice),
				allowRobots ? .empty : .meta(.name("robots"), .content("noindex")) ,
				.title(title),
				styleSheets,
				.favicon("/images/favicon.ico")
			),
			.body(
				.header(
					.a(
						.href("/"),
						.img(.src("/images/favicon.ico")),
						.h1(.text(title))
					),
					navigation
				),
				.main(
					.div(
						.id(mainContentID),
						content
					)
				),
				.script(.src("/javascript/frontend.js"))
			)
		)
	}
}
