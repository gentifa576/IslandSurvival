extends BaseState

@export var movement_component: MovementComponent
@export var dialog_component: DialogComponent

func enter(param: Dictionary):
	movement_component.paused = false
	dialog_component.set_process_input(true)
	pass
	
func exit():
	movement_component.paused = true
	dialog_component.set_process_input(false)
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass
