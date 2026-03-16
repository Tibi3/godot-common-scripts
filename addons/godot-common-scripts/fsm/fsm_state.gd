## Abstract base class for a [GCSFSM] state.
class_name GCSFSMState
extends Node

## The [GCSFSM] that manages this state.
var fsm: GCSFSM

## Called before changing state with [method GCSFSM.change_state]
func _on_exit() -> void:
	pass
