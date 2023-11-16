extends BaseState

@export var movement_component: AutoMovementComponent
@export var stats_component: StatsComponent
@export var relationship_component: RelationshipComponent
@export var task_component: TaskComponent

@onready var progress_bar: ProgressBar = $Control/ProgressBar
var current_progress: float = 0 
var in_progress: bool = false

var resource_yield: int = 0


func enter(_param: Dictionary):
	in_progress = true
	movement_component.pause = true
#	movement_component.target.visible = false
	relationship_component.interactable = false
	progress_bar.visible = true
	
	#add duration of task based on what task_component sees, applying NPC stat parameters
	#new interations need to be set here
	if task_component.resource_type == task_component.Type.WOOD:
		$Timer.wait_time = stats_component.get_woodcutting_speed()
		resource_yield = stats_component.get_woodcutting_yield()
	if task_component.resource_type == task_component.Type.STONE:
		$Timer.wait_time = stats_component.get_mining_speed()
		resource_yield = stats_component.get_mining_yield()
	$Timer.start()
	pass
	
func exit():
	relationship_component.interactable = true
	movement_component.target.visible = true
	progress_bar.value = 0 
	progress_bar.visible = false
	current_progress = 0
	in_progress = false
	$Timer.stop()
	pass

func process(_delta):
	#this code isn't being ran from state_manager
	show_task_progress()

func _process(_delta):
	show_task_progress()

func physics_process(_delta):
	pass

func show_task_progress():
	if !in_progress:
		progress_bar.visible = false
		return
	current_progress = 1.0 - float($Timer.time_left / $Timer.wait_time)

	progress_bar.value = current_progress
	pass

func _on_timer_timeout():
#	print(str(float(stats_component.current_capacity/ stats_component.capacity)) + " - " + str(progress_bar.value))
	stats_component.current_capacity += resource_yield
	if stats_component.current_capacity == stats_component.capacity:
		transition.emit(BaseState.States.WALK, {
			BaseState.Param.NEXT_STATE: BaseState.States.DEPOSIT,
			BaseState.Param.DESTINATION: task_component.deposit_destination
			}
		)
