## A basic Logger
##
## First you have to register a handler to see any logs.
## [codeblock]
## if OS.has_feature("editor"):
##  	# This one uses bbcode to format the logs. Useful in the editor, but looks bad in the terminal.
## 	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLER.DefaultEditorHandler.new())
## else:
##  	# This one does not use bbcode to format the logs.
##	GCS_Log.register_handler(GCS_Log.DEFAULT_HANDLER.DefaultConsoleHandler.new())
##
## # Check out "res://addons/godot-common-scripts/default_handlers.gd" to see how to implement you own handler.
## GCS_Log.debug("my debug message") # [22:30:56] DEBUG [res://main/main.gd:17]: my debug message
## [/codeblock]
class_name GCS_Log

const DEFAULT_HANDLERS := preload("uid://ogg7nscsqlno")

## Current Debug level.[br]
## [constant Level.DEBUG] shows all.[br]
## [constant Level.SILENT] shows none.
static var level := Level.DEBUG
static var _handlers: Array[Handler]

## Registers a handler.
static func register_handler(handler: Handler) -> void:
	_handlers.push_back(handler)


static func debug(msg: Variant, trace_offset := 0) -> void:
	if level > Level.DEBUG:
		return

	var from := _where(trace_offset)
	var time := Time.get_datetime_dict_from_system()

	for handler in _handlers:
		handler.debug(msg, from["source"], from["line"], time)


static func info(msg: Variant, trace_offset := 0) -> void:
	if level > Level.INFO:
		return

	var from := _where(trace_offset)
	var time := Time.get_datetime_dict_from_system()

	for handler in _handlers:
		handler.info(msg, from["source"], from["line"], time)


static func warn(msg: Variant, trace_offset := 0) -> void:
	if level > Level.WARNING:
		return

	var from := _where(trace_offset)
	var time := Time.get_datetime_dict_from_system()

	for handler in _handlers:
		handler.warn(msg, from["source"], from["line"], time)


static func err(msg: Variant, trace_offset := 0) -> void:
	if level > Level.ERROR:
		return

	var from := _where(trace_offset)
	var time := Time.get_datetime_dict_from_system()

	for handler in _handlers:
		handler.err(msg, from["source"], from["line"], time)


static func _where(offset: int) -> Dictionary:
	var stack := get_stack()
	if stack.is_empty():
		return { "file": "-", "line": 0 }

	return stack[2 + offset]


enum Level {
	DEBUG,
	INFO,
	WARNING,
	ERROR,
	SILENT
}

## An abstract base class for handling logging.
class Handler:
	func debug(_msg: Variant, _file: String, _line: int, _time: Dictionary) -> void:
		pass


	func info(_msg: Variant, _file: String, _line: int, _time: Dictionary) -> void:
		pass


	func warn(_msg: Variant, _file: String, _line: int, _time: Dictionary) -> void:
		pass


	func err(_msg: Variant, _file: String, _line: int, _time: Dictionary) -> void:
		pass
