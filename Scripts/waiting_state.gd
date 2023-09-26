extends BaseState

@onready var timer = $Timer

func enter():
	var wait_time = randf_range(2.0, 5.0)
	timer.wait_time = wait_time
	print("waiting for ", wait_time)
	timer.start()
	pass
	
func exit():
	timer.stop()
	pass

func _on_timer_timeout():
	transition.emit(States.WALK)
