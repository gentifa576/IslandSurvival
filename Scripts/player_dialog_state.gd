extends BaseState

@export var dialog_component: DialogComponent
signal close_dialog_press()
var with:Character

func enter():
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
	with.state_manager.transition(BaseState.States.DIALOG)
	transition.emit(BaseState.States.DIALOG)

func _input(event):
	if event.is_action_pressed("Cancel") and with:
		close_dialog_press.emit()

func _on_dialog_component_close_dialog():
	var has_tasks = !with.components[BaseComponent.Components.MOVE].task_destinations.is_empty()
	if has_tasks:
		with.state_manager.transition(BaseState.States.TASK)
	else:
		with.state_manager.transition(BaseState.States.WAIT)
		with.state_manager.transition(BaseState.States.WALK)
	transition.emit(BaseState.States.WALK)
	pass # Replace with function body.
