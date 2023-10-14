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

func initialize():
	#no resize required
	dialog_with = null
	canvas_layer.visible = false
	set_process_input(true)
	pass

func component_process(delta):
	pass
	
func component_physics_process(delta):
	pass

func _on_close_button_pressed():
	close_dialog.emit()
	initialize()
	close_button.pressed.disconnect(_on_close_button_pressed)
	talk_button.pressed.disconnect(_on_talk_button_pressed)
	gift_button.pressed.disconnect(_on_gift_button_pressed)
	
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


func _input_dialog_close():
	_on_close_button_pressed()
