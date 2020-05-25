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
//        let next = EventLoopPromise<NewValue>(eventLoop: eventLoop, file: file, line: line)
//        self._whenComplete {
//            switch self._value! {
//            case .success(let t):
//                let futureU = callback(t)
//                if futureU.eventLoop.inEventLoop {
//                    return futureU._addCallback {
//                        next._setValue(value: futureU._value!)
//                    }
//                } else {
//                    futureU.cascade(to: next)
//                    return CallbackList()
//                }
//            case .failure(let error):
//                return next._setValue(value: .failure(error))
//            }
//        }
//        return next.futureResult

		self.flatMap { value in
			do {
				return try callback(value)
			} catch {
				return self.eventLoop.future(error: error)
			}
		}
    }

}
