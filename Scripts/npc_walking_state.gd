extends BaseState

@export var movement_component: AutoMovementComponent
@export var movement_range: float

var path: PackedVector2Array
var destination

func enter():
	movement_component.target_reached.connect(reached)
	
	destination = randomized_destination()
	var target = movement_component.target
	var curr_world = target.curr_world
	while !curr_world.local_to_map_walkable(destination):
		destination = randomized_destination()
	destination = curr_world.local_to_map_coord(destination)
#	print("moving to ", destination)
	var val = curr_world.get_pathfind(curr_world.local_to_map_coord(target.position), destination)
	movement_component.destinations = val
	movement_component.pause = false
	pass
	
func exit():
	movement_component.target_reached.disconnect(reached)
	movement_component.pause = true
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

#func _unhandled_input(event):
#	if event is InputEventMouseButton && event.pressed:
#		var curr_world = movement_component.target.curr_world
#		var destination = curr_world.local_to_map_coord(event.position)
#		print("moving to ", destination)
#		movement_component.destination = destination

func reached():
	transition.emit(States.WAIT)
	pass

func randomized_destination():
	return movement_component.target.position + (Vector2(randf_range(-movement_range, movement_range), randf_range(-movement_range, movement_range)) * 32)
