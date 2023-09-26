extends BaseComponent

@export var speed = 32
var is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func component_process(delta):
	pass
	
func component_physics_process(delta):
	calculate_movement()
	if is_moving:
		target.move_and_slide()
	pass

func calculate_movement():
	var x_axis = Input.get_axis("ui_left", "ui_right")
	var y_axis = Input.get_axis("ui_up", "ui_down")
	if !Input.is_anything_pressed():
		target.velocity = Vector2.ZERO
		is_moving = false
	
	if Input.is_anything_pressed():
		target.velocity = Vector2(x_axis, y_axis).normalized() * speed
		is_moving = true
