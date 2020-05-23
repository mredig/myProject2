import Foundation

protocol FormFieldOptionRepresentable {
	var formFieldOption: FormFieldOption { get }
}

struct FormFieldOption: Encodable {
	public let key: String
	public let label: String
}
