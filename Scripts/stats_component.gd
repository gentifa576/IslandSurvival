extends BaseComponent
class_name StatsComponent

@export var capacity :int
@export var mining :float
@export var lumbery :float
# Might use this instead of the speed in movement component
@export var movement_speed :float

var current_capacity: int = 0:
	set(val):
		current_capacity = min(capacity, val)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func get_mining_speed() -> float:
	# mining is from 30s - 10s at the lowest per internal
#	return lerp(30, 10, mining/100)
	return 1.0

func get_mining_yield() -> int:
	# every 10 point mining yield is increased by 1
#	return mining / 10
	return capacity #testing

func get_woodcutting_speed() -> float:
	# woodcutting is from 20s - 5s at the lowest per internal
#	return lerp(20, 5, lumbery/100)
	return 1.0
	
func get_woodcutting_yield() -> int:
	# every 8 point wood yield is increased by 1
#	return lumbery / 8
	return capacity #testing
