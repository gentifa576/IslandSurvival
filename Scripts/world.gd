extends Node2D
class_name World

@onready var tile_map: TileMap = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func local_to_map_walkable(coord):
	var map_coord = tile_map.local_to_map(coord)
	var tile_data = tile_map.get_cell_tile_data(0, map_coord)
	return tile_data.get_custom_data("walkable")

func local_to_map_coord(coord):
	var map_coord = tile_map.local_to_map(coord)
	return tile_map.map_to_local(map_coord)
