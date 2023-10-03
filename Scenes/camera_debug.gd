extends Camera2D

@export var debug_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position_smoothing_enabled = true
	if debug_enabled:
		make_current()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if !debug_enabled:
		return
	
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
		self.position = event.position
#		print(event.global_position)
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_WHEEL_UP && event.pressed:
		#zoom in
		self.zoom += Vector2(0.2, 0.2)
		pass
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_WHEEL_DOWN && event.pressed:
		#zoom out
		self.zoom -= Vector2(0.2, 0.2)
		pass
