extends BaseComponent
class_name AutoMovementComponent

signal target_reached

@export var speed = 1
@onready var navigation = $NavigationAgent2D
var destination: Vector2
var is_moving = false

func initialize():
	destination = target.position
	pass

func component_process(delta):
	navigation.target_position = destination
	pass
	
func component_physics_process(delta):
	calculate_movement(delta)
	if is_moving:
		target.move_and_slide()
	pass
	
func calculate_movement(delta):
	if target.position.distance_to(destination) < 0.3:
#	var reaced = navigation.is_target_reached()
#	if navigation.is_target_reached():
		target_reached.emit()
		is_moving = false
		return
	
#	target.velocity = target.position.direction_to(destination) * speed * delta
	var next_path_position = navigation.get_next_path_position()
	target.velocity = target.position.direction_to(next_path_position).normalized() * speed * delta
	is_moving = true
