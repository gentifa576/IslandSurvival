extends BaseState

@export var movement_component: MovementComponent

func enter():
	movement_component.paused = false
	pass
	
func exit():
	movement_component.paused = true
	pass

func process(delta):
	pass

func physics_process(delta):
	pass
