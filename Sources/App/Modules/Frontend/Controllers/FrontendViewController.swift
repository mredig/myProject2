import Plot

protocol HomePageContext {
	var title: String { get }
	var header: String { get }
	var message: String { get }
	var email: String? { get }
}

struct FrontendViewController {

	func homepageView(_ context: HomePageContext) -> HTML {
		let homeComponent = HomeComponent(header: context.header, message: context.message, email: context.email)

		let indexView = IndexView.frontendIndex(titled: context.title, content: homeComponent.component)
		return indexView.view
	}

}
