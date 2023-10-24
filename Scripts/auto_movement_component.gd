extends BaseComponent
class_name AutoMovementComponent

signal target_reached

@export var speed = 320
var destinations: PackedVector2Array 
var is_moving = false
var pause = false

#PASSED FROM PLAYER'S DIALOGUE COMPONENT
var task_destinations = []
var task_current_step = 0
var task_in_progress = false

func initialize():
	destinations = []
	pass

func task_reset():
	task_destinations.clear()
	task_current_step = 0
	task_in_progress = false
	is_moving = false
	pause = true

func component_process(_delta):
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

func return_task_path():
	var path = target.curr_world.get_pathfind(target.curr_world.local_to_map_coord(target.position) - Vector2i(0,1), 
				target.curr_world.local_to_map_coord(task_destinations[task_current_step]))

	print(path)
	task_current_step = (task_current_step + 1) % task_destinations.size()
	return path

func calculate_movement(delta):
	if destinations.size() == 0:
		target_reached.emit()
		is_moving = false
		task_in_progress = false 
		#prevent break when tasks available
		if task_destinations.size() == 0:
			return

	if target.state_manager.current_state == BaseState.States.TASK:
		if !task_in_progress:
			destinations = return_task_path()
			task_in_progress = true
	

	var next_path = destinations[0]
	var next_path_position = next_path
	

	
	target.velocity = target.position.direction_to(next_path_position).normalized() * speed * delta
#	print(target.position, " ", next_path_position, " ", target.velocity, " ", target.position.distance_to(destinations[0]))
	is_moving = true

	if target.position.distance_to(next_path_position) < 1:
		destinations.remove_at(0)


