extends BaseState

@export var dialog_component: DialogComponent
var with

func enter():
	pass
	
func exit():
	with = null
	pass

func process(delta):
	pass

func physics_process(delta):
	pass

func _on_dialog_component_start_dialog(target: Character):
	self.with = target
	with.state_manager.transition(BaseState.States.DIALOG)
	transition.emit(BaseState.States.DIALOG)


func _on_dialog_component_close_dialog():
	with.state_manager.transition(BaseState.States.WAIT)
	transition.emit(BaseState.States.WALK)
	pass # Replace with function body.
