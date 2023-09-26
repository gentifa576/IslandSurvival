extends Node2D
class_name World

@onready var tile_map: AstarPathfinding = $TileMap
var start
var end

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
	return map_coord

func map_to_local(coord):
	var map_coord = tile_map.map_to_local(coord)
	return map_coord

func get_pathfind(start, end):
	var path = tile_map.get_pathfind(start, end)
	print(path)
	return path

func _input(event):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start = local_to_map_coord(event.global_position)
		else:
			end = local_to_map_coord(event.global_position)
#			print(get_pathfind(start, end))
