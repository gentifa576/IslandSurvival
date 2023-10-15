extends Node2D
class_name StructurePlacement

@export var sprite: ImageTexture
var is_valid = true

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.size = sprite.image.get_size()
	$ColorRect.position = sprite.image.get_size() / 2 * -1
	$ColorRect/Sprite2D.texture = sprite
	$ColorRect/Sprite2D.position = sprite.image.get_size() / 2
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if is_valid:
		$ColorRect.modulate = Color(0.14, 0.57, 1.00, 0.5)
	else:
		$ColorRect.modulate = Color(1.00, 0.14, 0.14, 0.5)
	pass
