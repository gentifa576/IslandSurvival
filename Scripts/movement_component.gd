extends BaseComponent
class_name MovementComponent

@export var speed = 320
@export var interaction_detector: RayCast2D
var is_moving = false
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func component_process(_delta):
	if paused:
		return
	pass
	
func component_physics_process(delta):
	if paused:
		return
	
	calculate_movement(delta)
	if is_moving:
		target.move_and_slide()
	pass

func calculate_movement(delta):
	var axis = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if !Input.is_anything_pressed():
#		print("released")
		target.velocity = Vector2.ZERO
		is_moving = false
	
	if Input.is_anything_pressed() && is_movement_key_pressed():
#		print(axis)
		target.velocity = axis.normalized() * speed * delta
		interaction_detector.target_position = axis.normalized() * 32
		is_moving = true

func is_movement_key_pressed():
	return Input.is_action_pressed("ui_left") || Input.is_action_pressed("ui_right") || Input.is_action_pressed("ui_up") || Input.is_action_pressed("ui_down") 
