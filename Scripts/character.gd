extends CharacterBody2D
class_name Character

@export var curr_world:World = get_parent()
@onready var state_manager:StateManager = %StateManager
var components = {}

func _ready():
	for component in self.get_node("%ComponentContainer").get_children():
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

func _on_dialog_component_close_dialog():
	pass # Replace with function body.
