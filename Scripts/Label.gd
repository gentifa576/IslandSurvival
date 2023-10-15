extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var current_text = text
	text = BaseState.States.keys()[get_parent().current_state] + "\n" + str($"../../ComponentContainer/RelationshipComponent".relationship_tracker)
	if(current_text != text):
		print(text)
