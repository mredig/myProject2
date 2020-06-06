import ViperKit
import ViewKit

protocol ViperAdminViewController: AdminViewController where Model: ViperModel {
	associatedtype Module: ViperModule

	var listView: String { get }
	var editView: String { get }
}

extension ViperAdminViewController {
	var listView: String {
		"\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/List"
	}

	var editView: String {
		"\(Module.name.capitalized)/Admin/\(Model.name.capitalized)/Edit"
	}
}
