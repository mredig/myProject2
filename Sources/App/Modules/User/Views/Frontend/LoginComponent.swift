import Plot

struct LoginComponent: HTMLViewComponent {

	let siwaClientId: String
	let siwaScope: String
	let siwaRedirectUrl: String
	let siwaState: String
	let siwaPopup: Bool

	var component: Node<HTML.BodyContext> {
		.section(
			.class("wrapper"),
			.form(
				.action("/sign-in"),
				.method(.post),

				.label(.for("email"), "Email:"),
				.input(
					.type(.email),
					.id("email"),
					.name("email"),
					.value(""),
					.class("field")
				),

				.label(.for("password"), "Password:"),
				.input(
					.type(.password),
					.id("password"),
					.name("password"),
					.value(""),
					.class("field")
				),

				.input(
					.type(.submit),
					.class("submit"),
					.value("Submit")
				)
			),

			.script(.src("https://appleid.cdn-apple.com/appleauth/static/jsapi/appleid/1/en_US/appleid.auth.js")),
			.div(
				.id("appleid-signin"),
				.data(named: "color", value: "black"),
				.data(named: "border", value: "false"),
				.data(named: "type", value: "sign in"),
				.class("signin-button")
			),
			.script("""
			AppleID.auth.init({
				clientId : '\(siwaClientId)',
				scope : '\(siwaScope)',
				redirectURI: '\(siwaRedirectUrl)',
				state : '\(siwaState)',
				usePopup : \(siwaPopup),
			});
			""")
		)
	}
}
