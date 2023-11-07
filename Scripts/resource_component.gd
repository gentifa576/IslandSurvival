extends BaseComponent

var wood: int:
	set(val):
		wood = val
		$VBoxContainer/Wood.text = "Wood: " + str(wood)
var stone: int:
	set(val):
		stone = val
		$VBoxContainer/Stone.text = "Stone: " + str(stone)

func initialize():
	self.position = Vector2.ZERO
	wood = 0
	stone = 0
	pass
