extends BaseComponent

@export var speed = 320
var is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func component_process(delta):
	pass
	
func component_physics_process(delta):
	calculate_movement(delta)
	if is_moving:
		target.move_and_slide()
	pass

func calculate_movement(delta):
	var axis = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if !Input.is_anything_pressed():
		target.velocity = Vector2.ZERO
		is_moving = false
	
	if Input.is_anything_pressed():
		target.velocity = axis.normalized() * speed * delta
		is_moving = true
