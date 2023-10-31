extends BaseState

@export var movement_component: AutoMovementComponent
@export var stats_component: StatsComponent
@export var relationship_component: RelationshipComponent

func enter(param: Dictionary):
	movement_component.target.visible = false
	relationship_component.interactable = false
	$Timer.wait_time = stats_component
	pass
	
func exit():
	relationship_component.interactable = true
	pass

func process(_delta):
	pass

func physics_process(_delta):
	pass
