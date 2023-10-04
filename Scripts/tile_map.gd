extends AstarPathfinding

var day_transition_progress: float = 1.0:
	set(val):
		day_transition_progress = min(1, max(0.3, val))
		pass
var day_transition_target = Global.Cycle.DAY

func _ready():
	pass

func _process(delta):
	set_layer_modulate(0, transition_progress(delta))
	pass
	
func transition_progress(delta):
	var operator
	match day_transition_target:
		Global.Cycle.DAY:
			operator = -1
		Global.Cycle.NIGHT:
			operator = 1
	day_transition_progress -= 0.5 * delta * operator
	return lerp(Color.DARK_MAGENTA, Color.WHITE, day_transition_progress)
	pass
