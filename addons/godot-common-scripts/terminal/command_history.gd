var _commands: PackedStringArray
var _current := -1

func command_sent(command: String) -> void:
	_commands.push_back(command)
	_current = _commands.size() - 1


func get_prev() -> String:
	if _current < 0:
		return ""

	var command := _commands[_current]

	_current -= 1
	return command


func get_next() -> String:
	if _current >= _commands.size() - 1:
		return ""

	_current += 1
	return _commands[_current]


func has_next() -> bool:
	return _current < _commands.size() - 1
