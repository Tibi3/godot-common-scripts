## Abstract base class for a [GCS_FSM].
class_name GCS_FSMState
extends Node

## The [GCS_FSM] that manages this state.
var fsm: GCS_FSM

## Called before changing state with [method GCS_FSM.change_state]
func _on_exit() -> void:
	pass
