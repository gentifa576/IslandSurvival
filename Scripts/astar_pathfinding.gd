extends TileMap
class_name AstarPathfinding

@onready var alg = AStarGrid2D.new()
@onready var used_cells = get_used_cells(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	alg.region = self.get_used_rect()
	alg.cell_size = Vector2(32, 32)
	alg.offset = alg.cell_size / 2
	alg.default_estimate_heuristic = AStarGrid2D.HEURISTIC_OCTILE
	alg.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	
	alg.update()
	
	add_obstacles()

func add_obstacles():
	for cell in used_cells:
		if !walkable_cell(cell):
			alg.set_point_solid(cell)
	
func get_pathfind(start, end):
	var path: PackedVector2Array = alg.get_point_path(start, end)
	print(path)
	if (path.size() > 0):
		path.remove_at(0)
	return path
	
func id(point):
	return (point.x + point.y) * (point.x + point.y + 1) / 2 + point.y

func walkable_cell(cell):
	if get_cell_tile_data(1, cell):
		return false
	return get_cell_tile_data(0, cell).get_custom_data("walkable")
