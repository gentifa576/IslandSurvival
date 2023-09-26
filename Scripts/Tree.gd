extends Node2D

#resource node - provide wood


#naive resource gather implement - hold interaction until timer completes
var completion_time:float = 100
var current_progress:float = 0
var progress_speed:float = 100
var in_progress:bool = false

var loot:int = 5
var emptied:bool = false #resources provided

func _process(delta):
	if in_progress:
		current_progress += progress_speed * delta
		check_completed()

func check_completed():
	if current_progress >= completion_time:
		stop_interaction(null)
		if not emptied:
			Global_Resources.wood += loot
			emptied = true

func interact(_state):
	check_completed()
	in_progress = true

func stop_interaction(_state):
	in_progress = false
	

