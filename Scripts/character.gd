extends CharacterBody2D

var components = []

func _ready():
	for component in $ComponentContainer.get_children():
		if component is BaseComponent:
			component.target = self
			component.initialize()
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
