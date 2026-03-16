@tool
extends EditorPlugin

func _enable_plugin() -> void:
	add_custom_type("GCSFSM", "Node", preload("uid://b8ev0ydjylqaa"), null)
	add_custom_type("GCSFSMState", "Node", preload("uid://dn3mklvw4s2te"), null)
	add_custom_type("GCSNodePool", "Node", preload("uid://bcdk64fem8ieb"), null)
	add_custom_type("GCSMultiNodePool", "Node", preload("uid://wx6n1tawnfyq"), null)


func _disable_plugin() -> void:
	remove_custom_type("GCSFSM")
	remove_custom_type("GCSFSMState")
	remove_custom_type("GCSNodePool")
	remove_custom_type("GCSMultiNodePool")


func _enter_tree() -> void:
	pass


func _exit_tree() -> void:
	pass
