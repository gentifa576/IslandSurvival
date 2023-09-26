extends Node2D

@export var current_state: BaseState.States
var state_dictionary = {}

# Called when the node enters the scene tree for the first time.
func start():
	for child in get_children():
		if child is BaseState:
			child.transition.connect(transition)
			state_dictionary[child.state] = child
			
	if !state_dictionary.has(current_state):
		return
	
	state_dictionary[current_state].enter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta):
	if !state_dictionary.has(current_state):
		return
	state_dictionary[current_state].process(delta)
	pass

func physics_process(delta):
	if !state_dictionary.has(current_state):
		return
	state_dictionary[current_state].physics_process(delta)
	pass
	
func transition(new_state):
	if current_state != new_state:
		state_dictionary[current_state].exit()
		state_dictionary[new_state].enter()
		current_state = new_state
	pass
