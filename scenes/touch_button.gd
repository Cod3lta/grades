extends Button
class_name TouchButton

var starting_position: Vector2

signal touch_pressed


func _gui_input(event: InputEvent) -> void:
	#if event is InputEventScreenTouch:
	if event is InputEventMouseButton:
		var position: Vector2 = event.global_position
		if event.pressed:
			starting_position = position
		elif starting_position.distance_to(position) < 20:
			touch_pressed.emit()
