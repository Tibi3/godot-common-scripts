extends Logger

static var ERROR_COLOR := Color(0.94, 0.273, 0.273, 1.0).to_html()

var _terminal: GCSTerminal

func _init(p_terminal: GCSTerminal) -> void:
	_terminal = p_terminal


func _log_error(function: String, file: String, line: int, code: String, rationale: String, editor_notify: bool, error_type: int, script_backtraces: Array[ScriptBacktrace]) -> void:
	_terminal.display("[ERROR] %s:%s:%d:[br]%s[br]%s[br]" % [file, function, line, code, rationale], ERROR_COLOR)
	for backtrace in script_backtraces:
		_terminal.display("%s[br]" % backtrace.format(4), ERROR_COLOR)
