extends CharacterBody2D

@export var curr_world:World
var components = []

func _ready():
	for component in $ComponentContainer.get_children():
		if component is BaseComponent:
			component.target = self
			component.initialize()
#			call_deferred("component_initialize", component)
			components.append(component)
	
	$StateManager.start()

func _process(delta):
	for component in components:
		component.component_process(delta)
	$StateManager.process(delta)
	pass

func _physics_process(delta):
	for component in components:
		component.component_physics_process(delta)
	$StateManager.physics_process(delta)
	pass

func component_initialize(component):
	await get_tree().physics_frame
	
	component.initialize()
