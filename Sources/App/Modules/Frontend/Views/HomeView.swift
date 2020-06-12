import Plot

enum HomeView {

	static func homeView(header: String, message: String, email: String?) -> Node<HTML.BodyContext> {

		let emailSection: Node<HTML.BodyContext>
		if let email = email {
			emailSection = .group([
				.p(.b(.text(email)), " is logged in."),
				.a(.href("/admin"), "Admin"),
				"&middot;",
				.a(.href("/logout"), "Logout"),
			])
		} else {
			emailSection = .a(.href("/sign-in"), "Sign in")
		}

		return .group([
			.section(
				.class("wrapper"),
				.h2(.text(header))
			),
			.section(
				.class("wrapper"),
				.p(.text(message))
			),
			.section(
				.class("wrapper"),
				emailSection
			),
		])
	}

}
