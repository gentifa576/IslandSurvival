extends Node2D
class_name World

@onready var tile_map: AstarPathfinding = $TileMap
@onready var day_timer: Timer = $DayTimer
@onready var night_timer: Timer = $NightTimer
var day_transition_progress: float = 1.0:
	set(val):
		day_transition_progress = min(1, max(0, val))
		pass
var day_transition_target = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	day_timer.timeout.connect(day_end)
	night_timer.timeout.connect(night_end)
	day_timer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	tile_map.set_layer_modulate(0, transition_progress(delta))
	pass

func local_to_map_walkable(coord):
	var map_coord = tile_map.local_to_map(coord)
	var tile_data = tile_map.get_cell_tile_data(0, map_coord)
	if tile_data:
		return tile_data.get_custom_data("walkable")
	else:
		return false

func local_to_map_coord(coord):
	var map_coord = tile_map.local_to_map(coord)
	return map_coord

func map_to_local(coord):
	var map_coord = tile_map.map_to_local(coord)
	return map_coord

func get_pathfind(start, end):
	var path = tile_map.get_pathfind(start, end)
	return path

func day_end():
	print("day end")
	night_timer.start()
	day_transition_target = 0
	pass

func night_end():
	print("night end")
	day_timer.start()
	day_transition_target = 1
	pass

func transition_progress(delta):
	var operator
	if day_transition_target == 0:
		operator = 1
	elif day_transition_target == 1:
		operator = -1
	day_transition_progress -= 0.5 * delta * operator
#	print(day_transition_progress)
	return lerp(Color.DARK_BLUE, Color.WHITE, day_transition_progress)
	pass
