extends Node2D

var wood:int = 0:
	set(new_value):
		if wood!= new_value:
			wood = new_value
			resource_UI_update.emit(new_value)

signal resource_UI_update(wood)

