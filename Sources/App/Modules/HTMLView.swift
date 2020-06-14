import Plot
import Vapor

typealias HTMLBodyNode = Node<HTML.BodyContext>
typealias HTMLHeadNode = Node<HTML.HeadContext>

protocol HTMLView {
	var html: HTML { get }
	var view: View { get }
	func futureView(on request: Request) -> EventLoopFuture<View>
}

extension HTMLView {
	var view: View {
		html.view
	}

	func futureView(on request: Request) -> EventLoopFuture<View> {
		html.futureView(on: request)
	}
}


protocol HTMLViewComponent {
	associatedtype ComponentType

	var component: ComponentType { get }
}


extension Array where Element == HTMLBodyNode {
	func joined(separatedBy separator: Element) -> [Element] {
		guard self.count > 1 else { return self }
		return self[1...].reduce(into: [first]) {
			$0.append(separator)
			$0.append($1)
		}.compactMap { $0 }
	}
}
