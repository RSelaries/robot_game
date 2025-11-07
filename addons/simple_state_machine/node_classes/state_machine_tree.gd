@tool @icon("uid://briocm2y3qbsm")
class_name StateMachineTree
extends Tree


@export var fsm_to_watch: StateMachine: set = _set_fsm_to_watch


func _ready() -> void:
	if not fsm_to_watch: return
	fsm_to_watch.state_changed.connect(_update_tree)
	if not fsm_to_watch.initial_state: return
	_update_tree()


func _update_tree(_st = null) -> void:
	clear()
	var current_state = fsm_to_watch.active_state
	if current_state == null:
		current_state = fsm_to_watch.initial_state
	var state_ancestors := fsm_to_watch.get_state_ancestors_name(current_state)
	state_ancestors.reverse()
	var current_item: TreeItem
	for ancestor in state_ancestors:
		current_item = create_item(current_item)
		current_item.set_text(0, ancestor)


func _set_fsm_to_watch(value: StateMachine) -> void:
	fsm_to_watch = value
	if value: _update_tree()
	
