extends CharacterBody2D
class_name Character

@export var curr_world:World
@onready var state_manager = $StateManager
var components = {}

func _ready():
	for component in $ComponentContainer.get_children():
		if component is BaseComponent:
			component.target = self
			component.initialize()
			if components.has(component.component_type):
				assert(false, "Similar component found already")
			components[component.component_type] = component
	
	state_manager.start()

func _process(delta):
	for component in components.values():
		component.component_process(delta)
	state_manager.process(delta)
	pass

func _physics_process(delta):
	for component in components.values():
		component.component_physics_process(delta)
	state_manager.physics_process(delta)
	pass
