extends Node
class_name BaseComponent

enum Components {MOVE, ANIMATE, DIALOG, RELATIONSHIP, BUILDING}

@export var component_type: Components
@export var target: Character

func initialize():
	pass

func component_process(delta):
	pass
	
func component_physics_process(delta):
	pass
