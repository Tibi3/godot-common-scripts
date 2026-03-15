extends Node

@onready var terminal: GCSTerminal = $CanvasLayer/Terminal

func _ready() -> void:
	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLERS.DefaultEditorHandler.new())
	GCS_Log.register_handler(GCSTerminal.TerminalLogHandler.new(terminal))

	GCS.info("Logger initialized.")

	helper()


func helper() -> void:
	load("asd")
