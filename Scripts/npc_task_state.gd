extends BaseState

@export var movement_component: AutoMovementComponent
@export var stats_component: StatsComponent
@export var relationship_component: RelationshipComponent
@export var task_component: TaskComponent

var resource_yield: int = 0

func enter(param: Dictionary):
	movement_component.pause = true
	movement_component.target.visible = false
	relationship_component.interactable = false
	if task_component.resource_type == task_component.Type.WOOD:
		$Timer.wait_time = stats_component.get_woodcutting_speed()
		resource_yield = stats_component.get_woodcutting_yield()
	if task_component.resource_type == task_component.Type.STONE:
		$Timer.wait_time = stats_component.get_mining_speed()
		resource_yield = stats_component.get_mininig_yield()
	$Timer.start()
	pass
	
func exit():
	relationship_component.interactable = true
	movement_component.target.visible = true
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass

func _on_timer_timeout():
	stats_component.current_capacity += resource_yield
	if stats_component.current_capacity == stats_component.capacity:
		transition.emit(BaseState.States.WALK, {
			BaseState.Param.NEXT_STATE: BaseState.States.DEPOSIT,
			BaseState.Param.DESTINATION: task_component.deposit_destination
			}
		)
