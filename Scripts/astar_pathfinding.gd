extends TileMap
class_name AstarPathfinding

@onready var alg = AStar2D.new()
@onready var used_cells = get_used_cells(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_points()
	connect_points()

func add_points():
	for cell in used_cells:
		if get_cell_tile_data(0, cell).get_custom_data("walkable"):
			alg.add_point(id(cell), cell, 1.0)
	
func connect_points():
	for cell in used_cells:
		var neighbors = [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
		for neighbor in neighbors:
			var next_cell = cell + neighbor
			if used_cells.has(next_cell):
				alg.connect_points(id(cell), id(next_cell), false)
	
func get_pathfind(start, end):
	var path: PackedVector2Array = alg.get_point_path(id(start), id(end))
	path.remove_at(0)
	return path
	
func id(point):
	return (point.x + point.y) * (point.x + point.y + 1) / 2 + point.y
