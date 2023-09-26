extends BaseComponent
class_name AutoMovementComponent

signal target_reached

@export var speed = 320
var destination: Vector2
var is_moving = false

func initialize():
	destination = target.position

func component_process(delta):
	for i in range(target.get_slide_collision_count()):
		print(target.get_slide_collision(i))
	pass
	
func component_physics_process(delta):
	calculate_movement(delta)
	if is_moving:
		target.move_and_slide()
	pass
	
func calculate_movement(delta):
	if target.position.distance_to(destination) < 0.3:
		target_reached.emit()
		is_moving = false
		return
	
	target.velocity = target.position.direction_to(destination) * speed * delta
	is_moving = true
