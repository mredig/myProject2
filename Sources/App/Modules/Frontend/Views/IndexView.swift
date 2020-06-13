import Plot

struct IndexView: HTMLView {
	let title: String
	let content: HTMLBodyComponent
	let allowRobots: Bool
	let styleSheets: HTMLHeadComponent
	let navigation: HTMLBodyComponent
	let mainContentID: String
	let pageScripts: HTMLBodyComponent

	static var normalNav: [HTMLBodyComponent] = [
		.a(.href("/"), "Home"),
		.a(.href("/blog"), "Blog"),
		.a(.href("#"), .onclick("javascript:about();"), "About")
	]

	static var adminNav: [HTMLBodyComponent] = [
		.a(.href("/"), "Home"),
		.a(.href("/admin"), "Admin"),
		.a(.href("/logout"), "Logout")
	]

	private init(title: String,
				 content: HTMLBodyComponent,
				 allowRobots: Bool = false,
				 styleSheets: [String],
				 navigationAnchorArray: [HTMLBodyComponent],
				 mainContentID: String,
				 pageScripts: [String]) {
		self.title = title
		self.content = content
		self.allowRobots = allowRobots

		let sheets = styleSheets.map { HTMLHeadComponent.stylesheet($0) }
		self.styleSheets = .group(sheets)

		self.navigation = .nav(
			.id("navigation"),
			.group(navigationAnchorArray.joined(separatedBy: HTMLBodyComponent.text(" &middot; ")))
		)

		self.mainContentID = mainContentID

		let scripts = pageScripts.map { HTMLBodyComponent.script(.src($0)) }
		self.pageScripts = .group(scripts)
	}

	static func frontendIndex(titled title: String, content: HTMLBodyComponent, navigationAnchorArray: [HTMLBodyComponent] = normalNav) -> Self {
		IndexView(title: title,
				  content: content,
				  allowRobots: true,
				  styleSheets: ["/css/frontend.css"],
				  navigationAnchorArray: navigationAnchorArray,
				  mainContentID: "content",
				  pageScripts: ["/javascript/frontend.js"])
	}

	static func adminIndex(titled title: String, content: HTMLBodyComponent, navigationAnchorArray: [HTMLBodyComponent] = adminNav) -> Self {
		IndexView(title: title,
				  content: content,
				  allowRobots: false,
				  styleSheets: ["/css/frontend.css", "/css/admin.css"],
				  navigationAnchorArray: navigationAnchorArray,
				  mainContentID: "main-content",
				  pageScripts: ["/javascript/admin.js"])
	}

	var view: HTML {
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
