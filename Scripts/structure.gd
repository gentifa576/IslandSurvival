extends Node2D
class_name Structure

@export var sprite: ImageTexture

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite2D.texture = sprite
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
