extends BaseComponent
class_name BuildingComponent

@export var temp_asset: Image
@export var build_placement: PackedScene
@export var direction_raycast: RayCast2D
@export var build_target: PackedScene

var placement: StructurePlacement
var can_build: bool

func initialize():
	can_build = false
	placement = build_placement.instantiate()
	placement.visible = false
	placement.sprite = ImageTexture.create_from_image(temp_asset)
	add_child(placement)
	pass

func component_process(_delta):
	var map_coord = target.curr_world.local_to_map_coord(target.global_position + direction_raycast.target_position * 3)
	var snap_coord = target.curr_world.map_to_local(map_coord)
	placement.global_position = snap_coord
	placement.is_valid = check_valid(map_coord)
	pass
	
func component_physics_process(_delta):
	pass

func _input(event):
	if event.is_action_pressed("Build"):
		placement.visible = true
#		print(direction_raycast.target_position)
		target.state_manager.transition(BaseState.States.BUILD, {})
		pass
	
	if can_build && direction_raycast.target_position != Vector2.ZERO && event.is_action_pressed("Interact") && placement.is_valid:
		var structure = build_target.instantiate()
		structure.sprite = ImageTexture.create_from_image(temp_asset)
		#TEMPORARILY ASSIGNING NODE GROUP resource_depot HERE - ATTACH TO SCENE LATER
		structure.add_to_group("resource_depot")
		var coord = target.curr_world.local_to_map_coord(target.global_position + direction_raycast.target_position * 3)
		target.curr_world.structure_container.add_structure(coord, structure)
		target.state_manager.transition(BaseState.States.WALK, {})
		
		placement.visible = false
		pass

func check_valid(map_coord: Vector2i) -> bool:
	var _vectors = []
	for i in range(-1, 2):
		for j in range(-1, 2):
			var check_coord = map_coord + Vector2i(i, j)
			if !target.curr_world.map_coord_walkable(check_coord):
				return false
	return true
