class DefaultEditorHandler:
	extends GCS_Log.Handler

	static var DEBUG_COLOR := Color(0.576, 0.206, 0.71, 1.0).to_html()
	static var INFO_COLOR := Color(0.253, 0.62, 0.79, 1.0).to_html()
	static var WARN_COLOR := Color(0.94, 0.54, 0.273, 1.0).to_html()
	static var ERROR_COLOR := Color(0.94, 0.273, 0.273, 1.0).to_html()

	func debug(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print_rich(_format("DEBUG", msg, DEBUG_COLOR, where["source"], where["line"], time))


	func info(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print_rich(_format("INFO ", msg, INFO_COLOR, where["source"], where["line"], time))


	func warn(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print_rich(_format("WARN ", msg, WARN_COLOR, where["source"], where["line"], time))


	func err(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print_rich(_format("ERROR", msg, ERROR_COLOR, where["source"], where["line"], time))


	static func _format(p_level: String, msg: Variant, color: String, file: String, line: int, time: Dictionary) -> String:
		return "[color=#%s][lb]%02d:%02d:%02d[rb] %s [lb]%s:%d[rb]: %s[/color]" % [color, time["hour"], time["minute"], time["second"], p_level, file, line, msg]


class DefaultConsoleHandler:
	extends GCS_Log.Handler

	func debug(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print(_format("DEBUG", msg, where["source"], where["line"], time))


	func info(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print(_format("INFO ", msg, where["source"], where["line"], time))


	func warn(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print(_format("WARN ", msg, where["source"], where["line"], time))


	func err(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		print(_format("ERROR", msg, where["source"], where["line"], time))


	static func _format(p_level: String, msg: Variant, file: String, line: int, time: Dictionary) -> String:
		return "[%02d:%02d:%02d] %s [%s:%d]: %s" % [time["hour"], time["minute"], time["second"], p_level, file, line, msg]


class TerminalEditorLogHandler:
	extends GCS_Log.Handler

	static var DEBUG_COLOR := Color(0.576, 0.206, 0.71, 1.0).to_html()
	static var INFO_COLOR := Color(0.253, 0.62, 0.79, 1.0).to_html()
	static var WARN_COLOR := Color(0.94, 0.54, 0.273, 1.0).to_html()
	static var ERROR_COLOR := Color(0.94, 0.273, 0.273, 1.0).to_html()

	var _terminal: GCSTerminal

	func _init(p_terminal: GCSTerminal) -> void:
		_terminal = p_terminal


	func debug(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("DEBUG", msg, where["source"], where["line"], time), DEBUG_COLOR)


	func info(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("INFO ", msg, where["source"], where["line"], time), INFO_COLOR)


	func warn(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("WARN ", msg, where["source"], where["line"], time), WARN_COLOR)


	func err(msg: Variant, trace_offset: int) -> void:
		var where := _where(trace_offset)
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("ERROR", msg, where["source"], where["line"], time), ERROR_COLOR)


	static func _format(p_level: String, msg: Variant, file: String, line: int, time: Dictionary) -> String:
		return "[lb]%02d:%02d:%02d[rb] %s [lb]%s:%d[rb]: %s[br]" % [time["hour"], time["minute"], time["second"], p_level, file, line, msg]


class TerminalDefaultLogHandler:
	extends GCS_Log.Handler

	static var DEBUG_COLOR := Color(0.576, 0.206, 0.71, 1.0).to_html()
	static var INFO_COLOR := Color(0.253, 0.62, 0.79, 1.0).to_html()
	static var WARN_COLOR := Color(0.94, 0.54, 0.273, 1.0).to_html()
	static var ERROR_COLOR := Color(0.94, 0.273, 0.273, 1.0).to_html()

	var _terminal: GCSTerminal

	func _init(p_terminal: GCSTerminal) -> void:
		_terminal = p_terminal


	func debug(msg: Variant, _trace_offset: int) -> void:
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("DEBUG", msg, time), DEBUG_COLOR)


	func info(msg: Variant, _trace_offset: int) -> void:
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("INFO ", msg, time), INFO_COLOR)


	func warn(msg: Variant, _trace_offset: int) -> void:
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("WARN ", msg, time), WARN_COLOR)


	func err(msg: Variant, _trace_offset: int) -> void:
		var time := Time.get_datetime_dict_from_system()
		_terminal.display(_format("ERROR", msg, time), ERROR_COLOR)


	static func _format(p_level: String, msg: Variant, time: Dictionary) -> String:
		return "[lb]%02d:%02d:%02d[rb] %s: %s[br]" % [time["hour"], time["minute"], time["second"], p_level, msg]
