@tool
extends EditorPlugin

const CUSTOM_TYPES := [
	["GCSFSM", "Node", preload("uid://b8ev0ydjylqaa"), null],
	["GCSFSMState", "Node", preload("uid://dn3mklvw4s2te"), null],
	["GCSNodePool", "Node", preload("uid://bcdk64fem8ieb"), null],
	["GCSMultiNodePool", "Node", preload("uid://wx6n1tawnfyq"), null],
]

func _enable_plugin() -> void:
	for custom_types in CUSTOM_TYPES:
		add_custom_type(custom_types[0], custom_types[1], custom_types[2], custom_types[3])


func _disable_plugin() -> void:
	for custom_types in CUSTOM_TYPES:
		remove_custom_type(custom_types[0])


func _enter_tree() -> void:
	pass


func _exit_tree() -> void:
	pass
