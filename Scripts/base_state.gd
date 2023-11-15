extends Node
class_name BaseState
enum States {WAIT=0, WALK=1, DIALOG=2, BUILD=3, TASK=4, DEPOSIT=5}
enum Param {NEXT_STATE, DESTINATION}

signal transition(new_state: States, param: Dictionary)

@export var state: States

func enter(_param: Dictionary):
	pass
	
func exit():
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass
