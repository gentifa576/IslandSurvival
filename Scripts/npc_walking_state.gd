extends BaseState

@export var movement_component: AutoMovementComponent
@export var movement_range: float

@onready var timer: Timer = $Timer

var path: PackedVector2Array
var destination

func enter():
	movement_component.target_reached.connect(reached)
	
	if movement_component.task_destinations.is_empty():
		destination = randomized_destination()
	else:
		destination = self.global_position
	var target = movement_component.target
	var curr_world = target.curr_world
	find_random_target(curr_world)
	destination = curr_world.local_to_map_coord(destination)
#	print("moving to ", destination)
	if destination:
		var val = curr_world.get_pathfind(curr_world.local_to_map_coord(target.position), destination)
		movement_component.destinations = val
		movement_component.pause = false
	pass
	
func exit():
	movement_component.target_reached.disconnect(reached)
	movement_component.pause = true
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass

func find_random_target(curr_world):
	timer.start()
	while !timer.is_stopped() && !curr_world.local_to_map_walkable(destination):
		destination = randomized_destination()
	
	if !destination:
		print("can't find destination")
		transition.emit(States.WAIT)

#func _unhandled_input(event):
#	if event is InputEventMouseButton && event.pressed:
#		var curr_world = movement_component.target.curr_world
#		var destination = curr_world.local_to_map_coord(event.position)
#		print("moving to ", destination)
#		movement_component.destination = destination

func reached():
	#PREVENT STATE CHANGE BACK TO WAIT WHILE IN TASK
	if movement_component.task_destinations.is_empty():
		transition.emit(States.WAIT)
	pass

func randomized_destination():
	return movement_component.target.position + (Vector2(randf_range(-movement_range, movement_range), randf_range(-movement_range, movement_range)) * 32)
