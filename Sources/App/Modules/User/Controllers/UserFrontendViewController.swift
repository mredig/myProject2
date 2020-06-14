import Plot


protocol LoginContext {
	var title: String { get }
	var clientId: String { get }
	var scope: String { get }
	var redirectUrl: String { get }
	var state: String { get }
	var popup: Bool { get }
}

struct UserFrontendViewController {

	func loginView(_ context: LoginContext) -> HTML {
		let loginComponent = LoginComponent(siwaClientId: context.clientId,
										   siwaScope: context.scope,
										   siwaRedirectUrl: context.redirectUrl,
										   siwaState: context.state,
										   siwaPopup: context.popup)

		let indexView = IndexView.frontendIndex(titled: context.title, content: loginComponent.component)
		return indexView.html
	}

}
