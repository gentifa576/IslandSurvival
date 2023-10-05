extends Node2D
class_name Structure

@export var sprite: ImageTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = sprite
	$StaticBody2D/CollisionShape2D.shape.size = Vector2(96, 32)
	$StaticBody2D/CollisionShape2D.position = Vector2(0, 32)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
