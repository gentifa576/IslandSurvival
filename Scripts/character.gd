extends CharacterBody2D
class_name Character

@export var curr_world:World
@onready var state_manager = $StateManager
var components = []

func _ready():
	for component in $ComponentContainer.get_children():
		if component is BaseComponent:
			component.target = self
			component.initialize()
#			call_deferred("component_initialize", component)
			components.append(component)
	
	state_manager.start()

func _process(delta):
	for component in components:
		component.component_process(delta)
	state_manager.process(delta)
	pass

func _physics_process(delta):
	for component in components:
		component.component_physics_process(delta)
	state_manager.physics_process(delta)
	pass

func component_initialize(component):
	await get_tree().physics_frame
	
	component.initialize()
