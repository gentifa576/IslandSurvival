extends Node
class_name BaseState
enum States {WAIT, WALK, DIALOG, BUILD, TASK}

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
