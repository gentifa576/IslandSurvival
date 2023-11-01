extends BaseState

@export var stat_component: StatsComponent
@export var task_component: TaskComponent

func enter(param: Dictionary):
	stat_component.current_capacity = 0
	$Timer.start()
	# temporarily just clears out inventory, will to do on adding it to the deposit location
	pass
	
func exit():
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass


func _on_timer_timeout():
	transition.emit(BaseState.States.WALK, {
			BaseState.Param.NEXT_STATE: BaseState.States.TASK,
			BaseState.Param.DESTINATION: task_component.target_destination
			}
		)
