extends Node

func _ready() -> void:
	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLERS.DefaultEditorHandler.new())
	GCS.info("Logger initialized.")
