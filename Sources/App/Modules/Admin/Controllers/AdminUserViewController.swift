import Plot

protocol AdminHomeContext {
	var title: String { get }
	var header: String { get }
	var message: String { get }
}

struct AdminUserViewController {

	func adminHomeView(_ context: AdminHomeContext) -> HTML {
		let homeComponent = AdminHomeComponent(header: context.header,
											   message: context.message)

		let indexView = IndexView.adminIndex(titled: context.title,
											 content: homeComponent.component)
		return indexView.view
	}

}
