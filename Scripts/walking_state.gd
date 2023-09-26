extends BaseState

@export var movement_component: AutoMovementComponent

func enter():
	movement_component.target_reached.connect(reached)
	var destination = movement_component.target.position + Vector2(randi_range(-5, 5) * 8, randi_range(-5, 5) * 8)
	print("moving to ", destination)
	movement_component.destination = destination
	pass
	
func exit():
	movement_component.target_reached.disconnect(reached)
	pass

func process(delta):
	print("until destination ", (movement_component.destination - movement_component.target.position))
	pass

func physics_process(delta):
	pass

func reached():
	transition.emit(States.WAIT)
	pass
