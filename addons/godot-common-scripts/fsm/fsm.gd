## Finate State Machine
##
## Add this node to your scene.[br]
## Create a state script and extend it from [GCSFSMState].[br]
## Change state like so: [codeblock] fsm.change_state(YourState.new())[/codeblock]
## Because Godot never has to instantiate a state you can excpect arguments in _init:
## [codeblock] fsm.change_state(StunnedState.new(5.0))[/codeblock]
class_name GCSFSM
extends Node

## Called after a state change happend.
signal state_changed

## If not specified will be set to [member owner].
@export var entity: Node

var _current_state: GCSFSMState

func _ready() -> void:
	if !is_instance_valid(entity):
		entity = owner


## - Calls [method GCSFSMState._on_exit] on the current [GCSFSMState].[br]
## - Adds [param state] as a child.
func change_state(state: GCSFSMState) -> void:
	if is_instance_valid(_current_state):
		_current_state._on_exit()
		_current_state.queue_free()

	_current_state = state
	_current_state.fsm = self
	add_child(_current_state)

	state_changed.emit()
