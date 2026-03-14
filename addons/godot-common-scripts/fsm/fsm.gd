## Finate State Machine
##
## Add this node to your scene.[br]
## Create a state script and extend it from [GCS_FSMState].[br]
## Change state like so: [codeblock] fsm.change_state(YourState.new())[/codeblock]
## Because Godot never has to instantiate a state you can excpect arguments in _init:
## [codeblock] fsm.change_state(StunnedState.new(5.0))[/codeblock]
class_name GCS_FSM
extends Node

## Called after a state changed happend.
signal state_changed

## If not specified will be set to [member owner]
@export var entity: Node

## The current state
var current_state: GCS_FSMState

func _ready() -> void:
	if !is_instance_valid(entity):
		entity = owner


## - Calls [method GCS_FSMState._on_exit] on [member current_state].[br]
## - Adds [param state] as a child.
func change_state(state: GCS_FSMState) -> void:
	if is_instance_valid(current_state):
		current_state._on_exit()
		current_state.queue_free()

	current_state = state
	current_state.fsm = self
	add_child(current_state)

	state_changed.emit()
