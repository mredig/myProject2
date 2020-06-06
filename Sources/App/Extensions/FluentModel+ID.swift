import Foundation
import Fluent

extension Fluent.Model where IDValue == UUID {
	var viewIdentifier: String { id!.uuidString }
}
