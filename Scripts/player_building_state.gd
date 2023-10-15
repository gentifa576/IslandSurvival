extends BaseState

@export var movement_component: MovementComponent
@export var building_component: BuildingComponent

var direction

func enter():
	movement_component.paused = false
	building_component.can_build = true
	pass
	
func exit():
	movement_component.paused = true
	building_component.can_build = false
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass
