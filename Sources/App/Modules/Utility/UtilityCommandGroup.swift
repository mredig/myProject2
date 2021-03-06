import Vapor

struct UtilityCommandGroup: CommandGroup {
	let commands: [String: AnyCommand]
	let help: String

	var defaultCommand: AnyCommand? {
		self.commands[UtilityFileTransferCommand.name]
	}

	init() {
		help = "Various utility tools"

		commands = [UtilityFileTransferCommand.name: UtilityFileTransferCommand(),]
	}
}
