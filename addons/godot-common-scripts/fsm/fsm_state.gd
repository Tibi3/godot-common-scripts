## Abstract base class for a [GCSFSM] state.
##
## See [GCSFSM] for examples.
class_name GCSFSMState
extends Node

## Emitted when a state change is requested.
signal state_change_requested(to: StringName)

## The [GCSFSM] that manages this state.
var fsm: GCSFSM

## Request the [GCSFSM] to change the state. [br]
## You have to set [member GCSFSM.state_change_table].[br]
## It is recommended to put the StringName keys into constants to avoid typos.
func request_state_change(to: StringName) -> void:
	state_change_requested.emit(to)


## Called before [GCSFSM] state change.
func _on_exit() -> void:
	pass
