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
#	NAIVE IMPLEMENTATION - SHOULD NOT FORCE STATE TRANSITION FROM HERE	
	dialog_with.state_manager.transition(BaseState.States.TASK)
#	NAIVE IMPLEMENTATION - SHOULD NOT UPDATE DESTINATIONS ON NPC FROM HERE
	var npc_movement:AutoMovementComponent = dialog_with.components[BaseComponent.Components.MOVE]
	
	#DEBUG - NAIVE IMPLEMENTATION
	#determine closest object to NPC with matching location group
	#pass these as a task_destination array to AutoMovmentComponent
	#AutoMovementComponent will loop through these 2 destinations while not in task state
	var destination
	for structure in dialog_with.curr_world.structure_container.get_children():
		if structure.is_in_group(location):
			if !destination:
				destination = structure
				continue
			var dist_to_structure = dialog_with.global_position.distance_to(structure.global_position)
			var dist_to_destination = dialog_with.global_position.distance_to(destination.global_position)
			if dist_to_structure < dist_to_destination:
				destination = structure
#	destination = dialog_with.curr_world.local_to_map_coord(destination.position)
	var current_position = dialog_with.global_position
	npc_movement.task_destinations = [destination.global_position,current_position]
	
	_on_close_button_pressed()
	
func _stop_task():
#	NAIVE IMPLEMENTATION - SHOULD NOT FORCE STATE TRANSITION FROM HERE
	dialog_with.state_manager.transition(BaseState.States.WAIT)
#	NAIVE IMPLEMENTATION - SHOULD NOT UPDATE DESTINATIONS ON NPC FROM HERE
	var npc_movement:AutoMovementComponent = dialog_with.components[BaseComponent.Components.MOVE]
	npc_movement.task_destinations.clear()
	
	_on_close_button_pressed()
	
