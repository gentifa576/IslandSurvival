extends BaseComponent
class_name RelationshipComponent

@export var cap_relationship = 100
@export var assist_threshold = 60
@export var gift_threshold = 80
var interactable
var relationship_tracker: int: 
	set(val):
		relationship_tracker = min(cap_relationship, val)

func initialize():
	relationship_tracker = 0
	interactable = true
	pass

func component_process(_delta):
	pass
	
func component_physics_process(_delta):
	pass

func increase_relationship(val: int):
	relationship_tracker += val
	print(relationship_tracker)
