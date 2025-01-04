extends MarginContainer
class_name SwipeDown

# higher number = more speed needed to close the screen
@export var quit_sensitivity: float = 2
# The 1st child that is a ScrollContainer
@export var scrollable_child: ScrollContainer
# The node that displays the content
@export var content_child: Control
# The number of the past frames analyzed for the gesture
@export var nb_frames_gesture: int = 10

signal swiping_down(percentage: float)
signal swiping_accepted(time_to_close: float)
signal swiping_rejected()
signal swiping_finished()

var last_touch_pos = null
var start_pos: Vector2
var gesture_quitting: bool = false
var quit_velocity: float = 0.0
var dismissable: bool = true
var nb_frames_since_start: int = 0
var velocity_last_frames: Array


func start_swipe_down(pos_y: float) -> void:
	nb_frames_since_start = 0
	velocity_last_frames.clear()
	velocity_last_frames.resize(nb_frames_gesture)
	velocity_last_frames.fill(0)


func swipe_down(event: InputEventScreenDrag) -> void:
	var difference_from_start: int = last_touch_pos - start_pos.y
	var percentage: float = difference_from_start / min(content_child.size.y, get_viewport_rect().size.y)
	swiping_down.emit(percentage)
	# register the gesture's y delta in the array
	# using a modulo to reduce performance cost
	velocity_last_frames[nb_frames_since_start % nb_frames_gesture] = int(event.position.y - last_touch_pos)
	nb_frames_since_start += 1
	add_theme_constant_override("margin_top", difference_from_start)


func end_swipe_down() -> void:
	var sum: int = velocity_last_frames.reduce(func(a, b): return a + b, 0)
	var avg: float = sum / velocity_last_frames.size()
	if avg > quit_sensitivity:
		accept_swipe_down()
	else:
		reject_swipe_down()


func accept_swipe_down() -> void:
	# Get the time needed to finish the swipe down
	var screen_size_y: float = get_viewport().get_visible_rect().size.y
	var nb_pixels_left = screen_size_y - content_child.get_screen_position().y
	var time_to_close: float = 0
	if quit_velocity != 0:
		time_to_close = nb_pixels_left / quit_velocity * 0.4
	time_to_close = clampf(time_to_close, 0.2, 0.4)
	
	if !has_theme_constant_override("margin_top"):
		add_theme_constant_override("margin_top", 0)
	# Animating the swipe down
	swiping_accepted.emit(time_to_close)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(
		self, 
		"theme_override_constants/margin_top", 
		get_viewport().get_visible_rect().size.y, 
		time_to_close)
	await tween.finished
	swiping_finished.emit()
	# Reset the margin_top value
	await get_tree().create_timer(0.1).timeout
	add_theme_constant_override("margin_top", 0)


func reject_swipe_down() -> void:
	var tween: Tween = get_tree().create_tween()
	swiping_rejected.emit()
	tween.tween_property(
		self, 
		"theme_override_constants/margin_top", 
		0, 
		0.3).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)


func detect_quit_gesture(event: InputEvent):
	if event is InputEventScreenTouch:
		if not event.canceled and event.pressed and last_touch_pos == null and scrollable_child.scroll_vertical == 0:
			# Start touching the screen from scroll_vertical == 0
			last_touch_pos = event.position.y
			start_pos = event.position
		else:
			if gesture_quitting == true:
				# Ends the quitting gesture
				end_swipe_down()
			last_touch_pos = null
			gesture_quitting = false
		
		if not event.canceled and not event.pressed and start_pos.y < content_child.global_position.y and start_pos.distance_to(event.position) < 20:
			# User taps above the page
			accept_swipe_down()
			
	elif event is InputEventScreenDrag && last_touch_pos != null:
		if event.position.y > last_touch_pos and not gesture_quitting:
			# Starts the quitting gesture
			start_swipe_down(event.position.y)
			gesture_quitting = true
		if gesture_quitting:
			swipe_down(event)
			last_touch_pos = event.position.y
			quit_velocity = event.velocity.y


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if is_visible_in_tree() and dismissable:
			detect_quit_gesture(event)
