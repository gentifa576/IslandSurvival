extends Node2D

#use: add this scene to objects that need to be interactable
class_name Interactable
#in node group "interactable" 


#catch with signal from player - player knows all Interactables that are within range
#signal pushes to only 1 object - closest in array
#TODO: Update with state logic as needed
func interact(state):
	get_parent().interact(state)

func stop_interaction(state):
	get_parent().stop_interaction(state)
