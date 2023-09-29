extends BaseComponent
class_name AutoMovementComponent

signal target_reached

@export var speed = 320
var destinations: PackedVector2Array
var is_moving = false
var pause = false

func initialize():
	destinations = []
	pass

func component_process(delta):
	if pause:
		return
	
	pass
	
func component_physics_process(delta):
	if pause:
		return
	
	calculate_movement(delta)
	if is_moving:
		target.move_and_slide()
	pass
	
func calculate_movement(delta):
	if destinations.size() == 0:
		target_reached.emit()
		is_moving = false
		return

	var next_path = destinations[0]
#	var next_path_position = target.curr_world.map_to_local(next_path)
	var next_path_position = next_path
	target.velocity = target.position.direction_to(next_path_position).normalized() * speed * delta
#	print(target.position, " ", next_path_position, " ", target.velocity, " ", target.position.distance_to(destinations[0]))
	is_moving = true

	if target.position.distance_to(next_path_position) < 1:
		destinations.remove_at(0)
