import Plot
import Vapor

extension HTML: ResponseEncodable {
	public func encodeResponse(for request: Request) -> EventLoopFuture<Response> {
		let rendered = render()
		let response = Response(status: .ok, headers: .init([("content-type", "text/html; charset=utf-8")]), body: .init(string: rendered))
		return request.eventLoop.makeSucceededFuture(response)
	}
}
