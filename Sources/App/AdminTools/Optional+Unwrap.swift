import Foundation
import Vapor

extension Optional {
	enum UnwrapError<Wrapped>: Error {
		case nilValue(_ wrapped: Wrapped.Type, foundAt: String)
	}

	func unwrap(file: StaticString = #file, line: UInt = #line) throws -> Wrapped {
		guard case .some(let value) = self else {
			throw UnwrapError.nilValue(Wrapped.self, foundAt: "Error unwrapping value in: \(file) at line: \(line)")
		}
		return value
	}
}


extension EventLoopFuture {
    public func flatMapFailable<NewValue>(file: StaticString = #file, line: UInt = #line, _ callback: @escaping (Value) throws -> EventLoopFuture<NewValue>) -> EventLoopFuture<NewValue> {
		self.flatMap { value in
			do {
				return try callback(value)
			} catch {
				return self.eventLoop.future(error: error)
			}
		}
    }

}
