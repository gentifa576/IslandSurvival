extends Node
class_name BaseState
enum States {WAIT=0, WALK=1, DIALOG=2, BUILD=3, TASK=4}

signal transition(new_state: States, args)

@export var state: States

func enter():
	pass
	
func exit():
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass
