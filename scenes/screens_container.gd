extends MarginContainer

var main_screen: Resource = preload("res://scenes/screens/main/main_screen.tscn")
var tenue_a_screen: Resource = preload("res://scenes/screens/tenue_a/tenue_a_screen.tscn")
var tenue_c_screen: Resource = preload("res://scenes/screens/tenue_c/tenue_c_screen.tscn")

var current_screen: int = 0

@export var node_container: Node

signal screen_changed(index: int)


func get_screen() -> Screen:
	if node_container.get_child_count() > 0:
		return node_container.get_current_tab_control()
	return null


func transition_to(screen: Resource, index: int) -> void:
	if index == current_screen: return
	var screen_instance = screen.instantiate()
	var old_screen = node_container.get_current_tab_control()
	node_container.current_tab = index
	#var dir: int = 1 if index > current_screen else -1
	# Moving the current screen
	#var tween1: Tween = get_tree().create_tween()
	#tween1.parallel()\
		#.tween_property(self, "theme_override_constants/margin_left", -dir * 150, 0.3)\
		#.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	#tween1.parallel().\
		#tween_property(self, "theme_override_constants/margin_right", dir * 150, 0.3)\
		#.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	#await tween1.finished
	
	#old_screen.queue_free()
	#node_container.add_child(screen_instance)
	
	#add_theme_constant_override("margin_left", dir * 150)
	#add_theme_constant_override("margin_right", -dir * 150)
	#
	#var tween2: Tween = get_tree().create_tween()
	#tween2.parallel()\
		#.tween_property(self, "theme_override_constants/margin_left", 0, 0.3)\
		#.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	#tween2.parallel().\
		#tween_property(self, "theme_override_constants/margin_right", 0, 0.3)\
		#.set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	#await old_screen.tree_exited
	screen_changed.emit(index)
	current_screen = index


func _on_button_nav_1_pressed() -> void:
	transition_to(main_screen, 0)


func _on_button_nav_2_pressed() -> void:
	transition_to(tenue_a_screen, 1)


func _on_button_nav_3_pressed() -> void:
	transition_to(tenue_c_screen, 2)
