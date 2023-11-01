extends BaseComponent
class_name StatsComponent

@export var capacity :int
@export var mining :int
@export var lumbery :int

var current_capacity: int = 0:
	set(val):
		current_capacity = min(capacity, val)

# Might use this instead of the speed in movement component
@export var movement_speed :int

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func get_mining_speed() -> int:
	# mining is from 30s - 10s at the lowest per internal
	return lerp(30, 10, mining/100)

func get_mining_yield() -> int:
	# every 10 point mining yield is increased by 1
	return mining / 10

func get_woodcutting_speed() -> int:
	# woodcutting is from 20s - 5s at the lowest per internal
	return lerp(20, 5, lumbery/100)
	
func get_woodcutting_yield() -> int:
	# every 8 point wood yield is increased by 1
	return lumbery / 8
