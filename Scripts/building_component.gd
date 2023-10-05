extends BaseComponent
class_name BuildingComponent

@export var temp_asset: Image
@export var build_placement: PackedScene
@export var direction_raycast: RayCast2D
@export var build_target: PackedScene

var placement: StructurePlacement
#var can_build: bool

func initialize():
#	can_build = false
	placement = build_placement.instantiate()
	placement.visible = false
	placement.sprite = ImageTexture.create_from_image(temp_asset)
	add_child(placement)
	pass

func component_process(delta):
	placement.position = direction_raycast.target_position * 2
	pass
	
func component_physics_process(delta):
	pass

func _input(event):
	if event.is_action_pressed("Build") :
		placement.visible = true
#		print(direction_raycast.target_position)
		target.state_manager.transition(BaseState.States.BUILD)
		pass
	
	if direction_raycast.target_position != Vector2.ZERO && event.is_action_pressed("Interact"):
		var structure = build_target.instantiate()
		structure.sprite = ImageTexture.create_from_image(temp_asset)
		var coord = target.curr_world.local_to_map_coord(target.global_position + direction_raycast.target_position * 2)
		target.curr_world.structure_container.add_structure(coord, structure)
		target.state_manager.transition(BaseState.States.WALK)
		
		placement.visible = false
		pass
