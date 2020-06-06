import Vapor
import Fluent
import ViperKit

struct UtilityModule: ViperModule {
	static var name = "utility"

	var commandGroup: CommandGroup? { UtilityCommandGroup() }
}
