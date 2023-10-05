extends Node2D
class_name StructureContainer

@export var curr_world: World

func add_structure(location_coord: Vector2i, object: Structure):
	object.position = curr_world.map_to_local(location_coord)
	add_child(object)
	
	curr_world.tile_map.set_cell(2, location_coord, 2, Vector2i(0, 4), 0)
	curr_world.update_pathfinding()
	pass
