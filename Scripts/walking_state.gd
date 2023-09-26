extends BaseState

@export var movement_component: AutoMovementComponent

func enter():
	movement_component.target_reached.connect(reached)
	
	var destination = randomized_destination()
	var curr_world = movement_component.target.curr_world
	while !curr_world.local_to_map_walkable(destination):
		destination = randomized_destination()
	destination = curr_world.local_to_map_coord(destination)
	print("moving to ", destination)
	movement_component.destination = destination
	pass
	
func exit():
	movement_component.target_reached.disconnect(reached)
	pass

func process(delta):
#	print("until destination ", (movement_component.destination - movement_component.target.position))
	pass

func physics_process(delta):
	pass

func reached():
	transition.emit(States.WAIT)
	pass

func randomized_destination():
	return movement_component.target.position + (Vector2(randi_range(-5, 5), randi_range(-5, 5)) * 8)
