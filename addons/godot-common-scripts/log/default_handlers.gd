class DefaultEditorHandler:
	extends GCS_Log.Handler

	static var DEBUG_COLOR := Color(0.576, 0.206, 0.71, 1.0).to_html()
	static var INFO_COLOR := Color(0.253, 0.62, 0.79, 1.0).to_html()
	static var WARN_COLOR := Color(0.94, 0.54, 0.273, 1.0).to_html()
	static var ERROR_COLOR := Color(0.94, 0.273, 0.273, 1.0).to_html()

	func debug(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		print_rich(_format("DEBUG", msg, DEBUG_COLOR, file, line, time))


	func info(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		print_rich(_format("INFO ", msg, INFO_COLOR, file, line, time))


	func warn(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		print_rich(_format("WARN ", msg, WARN_COLOR, file, line, time))


	func err(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		print_rich(_format("ERROR", msg, ERROR_COLOR, file, line, time))


	static func _format(p_level: String, msg: Variant, color: String, file: String, line: int, time: Dictionary) -> String:
		return "[color=#%s][lb]%02d:%02d:%02d[rb] %s [lb]%s:%d[rb]: %s[/color]" % [color, time["hour"], time["minute"], time["second"], p_level, file, line, msg]


class DefaultConsoleHandler:
	extends GCS_Log.Handler

	func debug(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		print(_format("DEBUG", msg, file, line, time))


	func info(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		print(_format("INFO ", msg, file, line, time))


	func warn(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		# We could use push_warning/push_error as well.
		print(_format("WARN ", msg, file, line, time))


	func err(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		print(_format("ERROR", msg, file, line, time))


	static func _format(p_level: String, msg: Variant, file: String, line: int, time: Dictionary) -> String:
		return "[%02d:%02d:%02d] %s [%s:%d]: %s" % [time["hour"], time["minute"], time["second"], p_level, file, line, msg]


class TerminalLogHandler:
	extends GCS_Log.Handler

	static var DEBUG_COLOR := Color(0.576, 0.206, 0.71, 1.0).to_html()
	static var INFO_COLOR := Color(0.253, 0.62, 0.79, 1.0).to_html()
	static var WARN_COLOR := Color(0.94, 0.54, 0.273, 1.0).to_html()
	static var ERROR_COLOR := Color(0.94, 0.273, 0.273, 1.0).to_html()

	var _terminal: GCSTerminal

	func _init(p_terminal: GCSTerminal) -> void:
		_terminal = p_terminal


	func debug(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		_terminal.display(_format("DEBUG", msg, file, line, time), DEBUG_COLOR)


	func info(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		_terminal.display(_format("INFO ", msg, file, line, time), INFO_COLOR)


	func warn(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		_terminal.display(_format("WARN ", msg, file, line, time), WARN_COLOR)


	func err(msg: Variant, file: String, line: int, time: Dictionary) -> void:
		_terminal.display(_format("ERROR", msg, file, line, time), ERROR_COLOR)


	static func _format(p_level: String, msg: Variant, file: String, line: int, time: Dictionary) -> String:
		return "[lb]%02d:%02d:%02d[rb] %s [lb]%s:%d[rb]: %s[br]" % [time["hour"], time["minute"], time["second"], p_level, file, line, msg]
