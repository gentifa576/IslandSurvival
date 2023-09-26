extends BaseComponent
class_name AutoMovementComponent

signal target_reached

@export var speed = 32
var destination: Vector2
var is_moving = false

func initialize():
	destination = target.position

func component_process(delta):
	pass
	
func component_physics_process(delta):
	calculate_movement()
	if is_moving:
		target.move_and_slide()
	pass
	
func calculate_movement():
	if target.position.distance_to(destination) < 0.3:
		target_reached.emit()
		is_moving = false
		return
	
	target.velocity = target.position.direction_to(destination) * speed
	is_moving = true
