import Foundation

struct FileFormField: Encodable {
	var value: String = ""
	var error: String?
	var data: Data?
	var delete = false
}
