extends BaseState

@export var dialog_component: DialogComponent
signal close_dialog_press()
var with:Character

func enter(param: Dictionary):
	pass
	
func exit():
	with = null
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass

func _on_dialog_component_start_dialog(target: Character):
	self.with = target
	with.state_manager.transition(BaseState.States.DIALOG, {})
	transition.emit(BaseState.States.DIALOG, {})

func _input(event):
	if event.is_action_pressed("Cancel") and with:
		close_dialog_press.emit()

func _on_dialog_component_close_dialog():
	transition.emit(BaseState.States.WALK, {})
	pass # Replace with function body.
