extends BaseState

@export var movement_component: AutoMovementComponent
@export var movement_range: float

@onready var timer: Timer = $Timer

var path: PackedVector2Array
var destination
var next_state: States = States.WAIT

func enter(param: Dictionary):
	movement_component.target_reached.connect(reached)
	if (param.has(Param.NEXT_STATE)):
		next_state = param[Param.NEXT_STATE];
	
	if (param.has(Param.DESTINATION)):
		destination = param[Param.DESTINATION]
	else:
		destination = randomized_destination()
	
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
		transition.emit(States.WAIT, {})

#func _unhandled_input(event):
#	if event is InputEventMouseButton && event.pressed:
#		var curr_world = movement_component.target.curr_world
#		var destination = curr_world.local_to_map_coord(event.position)
#		print("moving to ", destination)
#		movement_component.destination = destination

func reached():
	transition.emit(next_state, {})
	pass

func randomized_destination():
	return movement_component.target.position + (Vector2(randf_range(-movement_range, movement_range), randf_range(-movement_range, movement_range)) * 32)
