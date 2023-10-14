extends Camera2D

@export var default_zoom = Vector2(0.7,0.7)
@export var dialog_zoom = Vector2(1.2,1.2)


func _on_dialog_component_start_dialog(target):
	camera_zoom(dialog_zoom)


func _on_player_dialog_state_close_dialog_press():
	camera_zoom(default_zoom)
	
func camera_zoom(target:Vector2):
	var zoom_tween = create_tween()
	zoom_tween.set_ease(Tween.EASE_IN_OUT)
	zoom_tween.tween_property(self, "zoom", target, 0.2)
