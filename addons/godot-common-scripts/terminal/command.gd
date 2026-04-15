class_name GCSTerminalCommand

var name: String
var description: String
var subcommands: Dictionary[String, GCSTerminalCommand]
var args: Array[GCSTerminalCommandArg]

var effect: Callable

static func create (name: String) -> GCSTerminalCommandBuilder:
	return GCSTerminalCommandBuilder.new(name)


static func create_arg(name: String) -> GCSTerminalCommandArgBuilder:
	return GCSTerminalCommandArgBuilder.new(name)


class GCSTerminalCommandArg:
	var name: String
	var description: String


class GCSTerminalCommandArgBuilder:
	var _arg := GCSTerminalCommandArg.new()

	func _init(name: String) -> void:
		_arg.name = name


	func description(value: String) -> GCSTerminalCommandArgBuilder:
		_arg.description = value
		return self


	func build() -> GCSTerminalCommandArg:
		return _arg


class GCSTerminalCommandBuilder:
	var _command := GCSTerminalCommand.new()

	func _init(name: String) -> void:
		_command.name = name


	func description(value: String) -> GCSTerminalCommandBuilder:
		_command.description = value
		return self


	func effect(value: Callable) -> GCSTerminalCommandBuilder:
		_command.effect = value
		return self


	func subcommand(value: GCSTerminalCommand) -> GCSTerminalCommandBuilder:
		_command.subcommands[value.name] = value
		return self


	func arg(value: GCSTerminalCommandArg) -> GCSTerminalCommandBuilder:
		_command.args.push_back(value)
		return self


	func build() -> GCSTerminalCommand:
		return _command
