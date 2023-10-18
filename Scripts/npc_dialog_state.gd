extends BaseState

@export var movement_component:AutoMovementComponent

func enter():
	movement_component.pause = true
	
func exit():
	movement_component.pause = false

func process(_delta):
	pass

func physics_process(_delta):
	pass
