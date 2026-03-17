## Finate State Machine
##
## Supports both direct and table based state changes. [br]
## [br]Direct:
## [codeblock]
## class_name IdleState
## extends GCSFSMState
##
## func _ready() -> void:
##	(fsm.entity as Player).play_idle_anim()
##
## func _process(_delta) -> void:
##	if !is_zero_aprox((fsm.entity as Player).get_move_dir()):
##		# Changes to the run state
##		fsm.change_state(RunState.new())
## [/codeblock]
## [br]Table based:
## [codeblock]
## class_name IdleState
## extends GCSFSMState
##
## func _ready() -> void:
##	(fsm.entity as Player).play_idle_anim()
##
## func _process(_delta) -> void:
##	if !is_zero_aprox((fsm.entity as Player).get_move_dir()):
##		# Looks up &"run" in FSM.state_change_table and changes according to that.
##		request_transition(&"run")
## [/codeblock]
class_name GCSFSM
extends Node

## Called after a state change happend.
signal state_changed

## [b]Optional[/b]: If not specified will be set to [member owner].
@export var entity: Node
## [b]Optional[/b]: Set this only if you want to use [method GCSFSMState.request_state_change].
@export var state_change_table: GCSFSMStateChangeTable
## [b]Optional[/b]: It will automatically change to this state when [signal Node.ready].[br]
@export var starting_state: StringName

var _current_state: GCSFSMState

func _ready() -> void:
	if !is_instance_valid(entity):
		entity = owner

	if state_change_table && !starting_state.is_empty():
		change_state(state_change_table.table.get(starting_state).new())


## Changes the current state to [param state].[br]
## Calls [method GCSFSMState._on_exit] before adding the new [param state].
func change_state(state: GCSFSMState) -> void:
	if is_instance_valid(_current_state):
		_current_state._on_exit()
		_current_state.queue_free()

	_current_state = state
	_current_state.fsm = self
	if state_change_table:
		_current_state.state_change_requested.connect(_on_current_state_state_change_requested)

	add_child(_current_state)

	state_changed.emit()


func _on_current_state_state_change_requested(to: StringName) -> void:
	var state := state_change_table.table.get(to)
	assert(state)
	change_state(state.new())
