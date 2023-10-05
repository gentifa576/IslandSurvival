extends Node
class_name BaseState
enum States {WAIT, WALK, DIALOG, BUILD}

signal transition(new_state: States)

@export var state: States

func enter():
	pass
	
func exit():
	pass

func process(delta):
	pass

func physics_process(delta):
	pass
