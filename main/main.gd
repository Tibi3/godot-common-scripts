class_name Main
extends Node

@onready var terminal: GCSTerminal = $CanvasLayer/Terminal
@onready var terminal_2: GCSTerminal = $CanvasLayer/Terminal2

func _ready() -> void:
	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLERS.DefaultEditorHandler.new())
	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLERS.TerminalLogHandler.new(terminal))
	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLERS.TerminalLogHandler.new(terminal_2))

	GCS.info("Running in '%s' mode '%s' of the editor '%s' a browser on a '%s' - '%s'" % [
		"debug" if GCS.FEATURE_DEBUG else "release",
		"inside" if GCS.FEATURE_EDITOR else "outside",
		"in" if GCS.FEATURE_WEB else "not in",
		GCS.string_device(GCS.FEATURE_DEVICE),
		GCS.string_platform(GCS.FEATURE_PLATFORM),
	])

	terminal_2.register_command(GCSTerminalCommand.create("help")
			.description("Lists commands.")
			.effect(func (_args: PackedStringArray):
					var _help := GCS.lambda(func (commands: Array, indent: String, help: Callable):
							for command: GCSTerminalCommand in commands:
								terminal_2.display("[indent]%s[/indent]%s - %s[br]" % [indent, command.name, command.description])
								if !command.subcommands.is_empty():
									help.call(command.subcommands.values(), indent + "    ", help)

								if !command.args.is_empty():
									terminal_2.display("[indent]%s[/indent]Args:[br]" % indent)
									for arg in command.args:
										terminal_2.display("[indent]%s[/indent]    %s - %s[br]" % [indent, arg.name, arg.description]))
					_help.call(terminal_2._commands.values(), ""))
			.build())

	terminal_2.register_command(GCSTerminalCommand.create("pause")
			.description("Pauses the SceneTree.")
			.effect(func (_args: PackedStringArray):
					print("Pausing tree.")
					get_tree().paused = true)
			.build())

	terminal_2.register_command(GCSTerminalCommand.create("time")
			.description("Manages time.")
			.subcommand(GCSTerminalCommand.create("set")
					.description("Sets the current time.")
					.arg(GCSTerminalCommand.create_arg("time")
							.description("The time will be set to this value.")
							.build())
					.build())
			.effect(func (_args: PackedStringArray):
					terminal_2.display("Current time is 12:00.[br]"))
			.build())


func throw_error() -> void:
	load("asd")
