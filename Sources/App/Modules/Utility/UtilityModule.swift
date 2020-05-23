import Vapor
import Fluent

struct UtilityModule: Module {
	static var name = "utility"

	var commandGroup: CommandGroup? { UtilityCommandGroup() }
}
