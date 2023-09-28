extends BaseComponent
class_name DialogComponent

signal close_dialog()
signal start_dialog(target: Character)

@export var dialog_raycast: RayCast2D
var dialog_with: Character
var dialog_with_component: RelationshipComponent

func initialize():
	if !get_tree().get_root().size_changed.is_connected(resize):
		get_tree().get_root().size_changed.connect(resize)
	resize()
	dialog_with = null
	self.visible = false
	set_process_input(true)
	pass

func component_process(delta):
	pass
	
func component_physics_process(delta):
	pass

func _on_close_button_pressed():
	close_dialog.emit()
	initialize()
	$Container/CloseButton.pressed.disconnect(_on_close_button_pressed)
	$Container/InteractionContainer/TalkButton.pressed.disconnect(_on_talk_button_pressed)
	$Container/InteractionContainer/GiftButton.pressed.disconnect(_on_gift_button_pressed)
	
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
			self.visible = true
			start_dialog.emit(dialog_with)
			set_process_input(false)
			$Container/CloseButton.pressed.connect(_on_close_button_pressed)
			$Container/InteractionContainer/TalkButton.pressed.connect(_on_talk_button_pressed)
			$Container/InteractionContainer/GiftButton.pressed.connect(_on_gift_button_pressed)

func resize():
	$Container.size = get_viewport().get_visible_rect().size / 2
	$Container.position = $Container.size / 2 * -$Container.scale
