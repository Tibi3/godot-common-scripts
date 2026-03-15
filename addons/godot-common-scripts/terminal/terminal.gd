class_name GCSTerminal
extends PanelContainer

const HIGH_RES_THEME = preload("uid://b67ymri6053iv")
const LOW_RES_THEME = preload("uid://c3k3se2sctxhu")

@export var display_godot_errors := true
@export var toggle_action := &"dev_toggle_terminal"

var _header_grabbed := false
var _resize_grabbed := false
var _resize_started_at: Vector2
var _size_before_resize: Vector2
var _terminal_logger: TerminalLogger

@onready var _line_edit: LineEdit = %LineEdit
@onready var _rich_text_label: RichTextLabel = %RichTextLabel


func _ready() -> void:
	if display_godot_errors:
		_terminal_logger = TerminalLogger.new(self)
		OS.add_logger(_terminal_logger)

	set_process_unhandled_input(InputMap.has_action(toggle_action))


func _exit_tree() -> void:
	if is_instance_valid(_terminal_logger):
		OS.remove_logger(_terminal_logger)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(toggle_action):
		toggle(!visible)


static func create(p_at := Vector2.ZERO, p_theme: Theme = null) -> GCSTerminal:
	const TERMINAL = preload("uid://brn6rc5o83vcc")
	var terminal := TERMINAL.instantiate() as GCSTerminal
	terminal.position = p_at
	if is_instance_valid(p_theme):
		terminal.theme = p_theme
	return terminal


func toggle(value: bool) -> void:
	visible = !visible
	_header_grabbed = false
	_resize_grabbed = false


func display(command: String, color := Color.GRAY) -> void:
	_rich_text_label.push_color(color)
	_rich_text_label.append_text(command)
	_rich_text_label.pop()


func send_command(command: String) -> void:
	display("> %s[br]" % command)


func _on_header_panel_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		_header_grabbed = event.pressed
	elif _header_grabbed && event is InputEventMouseMotion:
		position = (position + event.relative as Vector2)


func _on_line_edit_text_submitted(new_text: String) -> void:
	_line_edit.clear()
	send_command(new_text)


func _on_resize_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		_resize_grabbed = event.pressed
		_resize_started_at = get_global_mouse_position()
		_size_before_resize = size
	elif _resize_grabbed && event is InputEventMouseMotion:
		var relative := get_global_mouse_position() - _resize_started_at
		size = (_size_before_resize + relative).max(Vector2(16, 16))


class TerminalLogger:
	extends Logger

	static var ERROR_COLOR := Color(0.94, 0.273, 0.273, 1.0).to_html()

	var _terminal: GCSTerminal

	func _init(p_terminal: GCSTerminal) -> void:
		_terminal = p_terminal

	func _log_error(function: String, file: String, line: int, code: String, rationale: String, editor_notify: bool, error_type: int, script_backtraces: Array[ScriptBacktrace]) -> void:
		_terminal.display("[ERROR] %s:%s:%d:[br]%s[br]%s[br]" % [file, function, line, code, rationale], ERROR_COLOR)
		for backtrace in script_backtraces:
			_terminal.display("%s[br]" % backtrace.format(4), ERROR_COLOR)


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
