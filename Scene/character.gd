extends Node2D

@onready var movement_dictionary = {
	KEY_W: Vector2.UP,
	KEY_A: Vector2.LEFT,
	KEY_S: Vector2.DOWN,
	KEY_D: Vector2.RIGHT
}
@onready var left_collision: RayCast2D = $LeftCollision
@onready var right_collision: RayCast2D = $RightCollision
@export var velocity = 1
var direction
var is_moving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if left_collision.is_colliding() || right_collision.is_colliding():
		is_moving = false
	pass
	
func _physics_process(delta):
	if is_moving:
		position += direction.normalized() * velocity * delta

func _unhandled_key_input(event):
	var move_direction = movement_dictionary[event.key_label]
	if !event.pressed && move_direction:
		is_moving = false
		direction = Vector2.ZERO
#		left_collision.target_position = Vector2.ZERO
#		right_collision.target_position = Vector2.ZERO
	
	if event.pressed && move_direction:
		direction = movement_dictionary[event.key_label] * 16
		if move_direction.abs().x > 0:
			left_collision.target_position = Vector2(move_direction.x * 16, -16)
			right_collision.target_position = Vector2(move_direction.x * 16, 16)
		if move_direction.abs().y > 0:
			left_collision.target_position = Vector2(-16, move_direction.y * 16)
			right_collision.target_position = Vector2(16, move_direction.y * 16)
		
		if left_collision.is_colliding() || right_collision.is_colliding():
			return
		else:
			is_moving = true
