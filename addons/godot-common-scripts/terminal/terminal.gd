class_name GCSTerminal
extends PanelContainer

const OsTerminalLogger = preload("uid://c3qtba5wl7t52")
const CommandHistory = preload("uid://dn8orai6fh1sa")

const HIGH_RES_THEME = preload("uid://b67ymri6053iv")
const LOW_RES_THEME = preload("uid://c3k3se2sctxhu")

@export var display_godot_errors := true
@export var toggle_action := &"dev_toggle_terminal"

var _header_grabbed := false
var _resize_grabbed := false
var _resize_started_at: Vector2
var _size_before_resize: Vector2
var _terminal_logger: OsTerminalLogger
var _history := CommandHistory.new()
var _current_command: String
var _commands: Dictionary[String, GCSTerminalCommand]

@onready var _line_edit: LineEdit = %LineEdit
@onready var _rich_text_label: RichTextLabel = %RichTextLabel
@onready var _suggestion_container: VBoxContainer = %SuggestionVBoxContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	if display_godot_errors:
		_terminal_logger = OsTerminalLogger.new(self)
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


func register_command(command: GCSTerminalCommand) -> void:
	_commands[command.name] = command


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
	_history.command_sent(command)

	var parts := parse_command(command)

	var cmd := _commands.get(parts[0]) as GCSTerminalCommand
	if cmd == null:
		display("Unknown command: '%s'[br]" % parts[0])
		return

	cmd.effect.call(parts)


func parse_command(command: String) -> PackedStringArray:
	if command.is_empty():
		return []

	var inside_literal := false
	var index := -1
	var word_start_at := 0

	var res := PackedStringArray()

	for char in command:
		index += 1

		if inside_literal:
			if char == "\"":
				inside_literal = false
				res.push_back(command.substr(word_start_at, index - word_start_at))
				word_start_at = index + 1
				continue

			continue

		if char == "\"":
			inside_literal = true
			word_start_at = index + 1
			continue

		if char == " " || char == "\t":
			if word_start_at != index:
				res.push_back(command.substr(word_start_at, index - word_start_at))
			word_start_at = index + 1
			continue

	var last := command.substr(word_start_at)
	if !last.is_empty():
		res.push_back(last)

	return res


func _on_header_panel_container_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		_header_grabbed = event.pressed
	elif _header_grabbed && event is InputEventMouseMotion:
		position = (position + event.relative as Vector2)


func _on_line_edit_text_submitted(new_text: String) -> void:
	_line_edit.clear()
	if !new_text.is_empty():
		send_command(new_text)


func _on_resize_label_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		_resize_grabbed = event.pressed
		_resize_started_at = get_global_mouse_position()
		_size_before_resize = size
	elif _resize_grabbed && event is InputEventMouseMotion:
		var relative := get_global_mouse_position() - _resize_started_at
		size = (_size_before_resize + relative).max(Vector2(16, 16))


func _on_pause_button_pressed(button: Button) -> void:
	var paused := get_tree().paused
	button.text = "Pause" if paused else "Unpause"
	get_tree().paused = !paused


func _on_line_edit_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_focus_next"):
		get_tree().root.set_input_as_handled()
		return

	if !event.is_pressed():
		return

	if event.is_action(&"ui_up"):
		if !_history.has_next():
			_current_command = _line_edit.text

		var prev := _history.get_prev()
		if !prev.is_empty():
			_line_edit.text = prev

		get_tree().root.set_input_as_handled()
	elif event.is_action(&"ui_down"):
		var next := _history.get_next()
		_line_edit.text = _current_command if next.is_empty() else next
		get_tree().root.set_input_as_handled()
