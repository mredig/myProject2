import Plot

struct HomeComponent: HTMLViewComponent {

	let header: String
	let message: String
	let email: String?

	var component: HTMLBodyNode {
		let emailSection: HTMLBodyNode
		if let email = email {
			emailSection = .group([
				.p(.b(.text(email)), " is logged in."),
				.a(.href("/admin"), "Admin"),
				" &middot; ",
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
