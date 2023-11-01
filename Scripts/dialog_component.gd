extends BaseComponent
class_name DialogComponent

signal close_dialog()
signal start_dialog(target: Character)

@export var dialog_raycast: RayCast2D
var dialog_with: Character
var dialog_with_component: RelationshipComponent


@onready var canvas_layer = $CanvasLayer
@onready var container = $CanvasLayer/Container
@onready var close_button = $CanvasLayer/Container/CloseButton
@onready var gift_button = $CanvasLayer/Container/InteractionContainer/GiftButton
@onready var talk_button = $CanvasLayer/Container/InteractionContainer/TalkButton

#testing task sending
@onready var trees_button = $CanvasLayer/Container/InteractionContainer/TreesButton
@onready var cave_button = $CanvasLayer/Container/InteractionContainer/CaveButton
@onready var stop_button = $CanvasLayer/Container/InteractionContainer/StopButton

func initialize():
	#no resize required
	dialog_with = null
	canvas_layer.visible = false
	set_process_input(true)
	pass

func component_process(_delta):
	pass
	
func component_physics_process(_delta):
	pass

func _on_close_button_pressed():
	close_dialog.emit()
	initialize()
	close_button.pressed.disconnect(_on_close_button_pressed)
	talk_button.pressed.disconnect(_on_talk_button_pressed)
	gift_button.pressed.disconnect(_on_gift_button_pressed)
	trees_button.pressed.disconnect(_send_to_location)
	cave_button.pressed.disconnect(_send_to_location)
	stop_button.pressed.disconnect(_stop_task)


func _on_talk_button_pressed():
	dialog_with_component.increase_relationship(1)
	pass # Replace with function body.
	
func _on_gift_button_pressed():
	dialog_with_component.increase_relationship(2)
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Interact") && dialog_raycast.is_colliding() && dialog_raycast.get_collider() is Character:
		if dialog_raycast.get_collider().components.has(BaseComponent.Components.RELATIONSHIP):
			dialog_with = dialog_raycast.get_collider()
			dialog_with_component = dialog_with.components[BaseComponent.Components.RELATIONSHIP]
			if (!dialog_with_component.interactable):
				return
			canvas_layer.visible = true
			start_dialog.emit(dialog_with)
			set_process_input(false)
			close_button.pressed.connect(_on_close_button_pressed)
			talk_button.pressed.connect(_on_talk_button_pressed)
			gift_button.pressed.connect(_on_gift_button_pressed)
			trees_button.pressed.connect(_send_to_location.bind("forest"))
			cave_button.pressed.connect(_send_to_location.bind("cave"))
			stop_button.pressed.connect(_stop_task)


func _input_dialog_close():
	_on_close_button_pressed()
	

func _send_to_location(location):
	if !location:
		return
	var npc_movement:AutoMovementComponent = dialog_with.components[BaseComponent.Components.MOVE]
#	npc_movement.task_reset()
	#determine closest object to NPC with matching location group
	#pass these as a task_destination array to AutoMovmentComponent
	#AutoMovementComponent will loop through these 2 destinations while not in task state
	var task_dest
	var second_dest
	for structure in dialog_with.curr_world.structure_container.get_children():
		#use "location" string to find nodes of the correct resource
		if structure.is_in_group(location):
			if !task_dest:
				task_dest = structure 
				continue
			var dist_to_structure = dialog_with.global_position.distance_to(structure.global_position)
			var dist_to_destination = dialog_with.global_position.distance_to(task_dest.global_position)
			if dist_to_structure < dist_to_destination:
				task_dest = structure
				
		#find resource depots
		if structure.is_in_group("resource_depot"):
			if !second_dest:
				second_dest = structure
				continue
			var dist_to_structure = dialog_with.global_position.distance_to(structure.global_position)
			var dist_to_destination = dialog_with.global_position.distance_to(second_dest.global_position)
			if dist_to_structure < dist_to_destination:
				second_dest= structure
			
	if !second_dest:
		second_dest = dialog_with
	
#	npc_movement.task_destinations = [task_dest.position,second_dest.position]
	npc_movement.is_moving = true
	npc_movement.pause = false
	dialog_with.components[BaseComponent.Components.TASK].target_destination = task_dest.position
	dialog_with.components[BaseComponent.Components.TASK].deposit_destination = second_dest.position
	if (location == "forest"):
		dialog_with.components[BaseComponent.Components.TASK].resource_type = TaskComponent.Type.WOOD
	if (location == "CAVE"):
		dialog_with.components[BaseComponent.Components.TASK].resource_type = TaskComponent.Type.STONE
	dialog_with.curr_world.debug_pathfind(second_dest.position, task_dest.position)
	dialog_with.state_manager.transition(BaseState.States.WALK, 
	{
		BaseState.Param.NEXT_STATE: BaseState.States.TASK, 
		BaseState.Param.DESTINATION: task_dest.position
	})
	call_deferred("_on_close_button_pressed")
	
func _stop_task():
	var npc_movement:AutoMovementComponent = dialog_with.components[BaseComponent.Components.MOVE]
	dialog_with.state_manager.transition(BaseState.States.WAIT, {})
	call_deferred("_on_close_button_pressed")
	
