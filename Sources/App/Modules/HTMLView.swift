import Plot

typealias HTMLBodyComponent = Node<HTML.BodyContext>
typealias HTMLHeadComponent = Node<HTML.HeadContext>

protocol HTMLView {
	var view: HTML { get }
}

protocol HTMLViewComponent {
	associatedtype ComponentType

	var component: ComponentType { get }
}


extension Array where Element == HTMLBodyComponent {
	func joined(separatedBy separator: Element) -> [Element] {
		guard self.count > 1 else { return self }
		return self[1...].reduce(into: [first]) {
			$0.append(separator)
			$0.append($1)
		}.compactMap { $0 }
	}
}
