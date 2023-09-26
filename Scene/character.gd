extends CharacterBody2D

var components = []

func _ready():
	for component in $ComponentContainer.get_children():
		if component is BaseComponent:
			components.append(component)

func _process(delta):
	for component in components:
		component.component_process(delta)
	pass

func _physics_process(delta):
	for component in components:
		component.component_physics_process(delta)
	pass
