class_name CardStateMachine
extends Node

@export var initial_state: cardstate

var current_state: cardstate
var states := {}


func init(card: cardui) -> void:
	for child: cardstate in get_children():
		if child:
			states[child.state] = child
			child.transition_requested.connect(_on_transition_requested)
			child.card_ui = card
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state


func on_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_input(event)


func on_gui_input(event: InputEvent) -> void:
	if current_state:
		current_state.on_gui_input(event)


func on_mouse_entered() -> void:
	if current_state:
		current_state.on_mouse_entered()


func on_mouse_exited() -> void:
	if current_state:
		current_state.on_mouse_exited()


func _on_transition_requested(from: cardstate, to: cardstate.State) -> void:
	if from != current_state:
		return
		
	var new_state: cardstate = states[to]
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	current_state = new_state
