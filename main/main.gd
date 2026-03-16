class_name Main
extends Node

@onready var terminal: GCSTerminal = $CanvasLayer/Terminal

func _ready() -> void:
	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLERS.DefaultEditorHandler.new())
	GCS_Log.register_handler(GCSTerminal.TerminalLogHandler.new(terminal))

	GCS.info("Running in '%s' mode '%s' of the editor '%s' a browser on a '%s' - '%s'" % [
		"debug" if GCS.FEATURE_DEBUG else "release",
		"inside" if GCS.FEATURE_EDITOR else "outside",
		"in" if GCS.FEATURE_WEB else "not in",
		GCS.string_device(GCS.FEATURE_DEVICE),
		GCS.string_platform(GCS.FEATURE_PLATFORM),
	])


func throw_error() -> void:
	load("asd")
