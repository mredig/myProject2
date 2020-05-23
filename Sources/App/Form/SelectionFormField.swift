import Foundation

struct SelectionFormField: Encodable {
	var value: String = ""
	var error: String?
	var options: [FormFieldOption] = []
}
