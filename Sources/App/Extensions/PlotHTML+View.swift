import Plot
import Vapor

extension HTML {
	public var view: View {
		View(data: .init(string: render()))
	}

	public func futureView(on request: Request) -> EventLoopFuture<View> {
		request.eventLoop.future(view)
	}
}
