extends Node2D
class_name StructureContainer

@export var curr_world: World
var cave_resource: int
var forest_resource: int

func _ready():
	cave_resource = 0
	forest_resource = 0

func add_structure(location_coord: Vector2i, object: Structure):
	object.position = curr_world.map_to_local(location_coord)
	add_child(object)
	
	var collision_coord = location_coord - Vector2i(0, -1)
	for i in range (0, 1):
		curr_world.tile_map.set_cell(3, collision_coord + Vector2i(i, 0), 2, Vector2i(4, 0), 0)
	curr_world.update_pathfinding()
	pass
