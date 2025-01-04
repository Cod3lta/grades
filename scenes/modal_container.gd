extends MarginContainer

@export var node_container: Node
@export var background_color: Color

var closing: bool = false


func _ready() -> void:
	$ColorRect.color = Color(0, 0, 0, 0.5)


func _process(_delta: float) -> void:
	%FullHeight.custom_minimum_size.y = get_viewport().get_visible_rect().size.y


func get_modal() -> Page:
	if node_container.get_child_count() > 0 and not closing:
		return node_container.get_child(0)
	return null


func get_panel() -> PanelContainer:
	return $ModalSwipeDown/ScrollContainer/FullHeight/MarginContainer/PanelContainer


func set_modal_margin_top(margin_top: int) -> void:
	$ModalSwipeDown/ScrollContainer/FullHeight/MarginContainer.add_theme_constant_override("margin_top", margin_top)


func show_modal(modal_opener: Control, button: Control) -> void:
	set_modal_margin_top(650)
	var modal_instance: Control = modal_opener.linked_modal.instantiate()
	%ModalSwipeDown.dismissable = modal_opener.dismissable
	modal_instance.modal_container = self
	modal_instance.setup(button)
	node_container.add_child(modal_instance)
	
	visible = true
	var modal_size_y: float = get_panel().size.y
	modal_size_y = min(modal_size_y, get_viewport_rect().size.y)
	%ModalSwipeDown.add_theme_constant_override("margin_top", modal_size_y)
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	tween.tween_property(%ModalSwipeDown, "theme_override_constants/margin_top", 0, 0.5)
	tween.tween_property($ColorRect, "color", Color(background_color, 0.7), 0.5)


func close_modal() -> void:
	%ModalSwipeDown.accept_swipe_down()


func _on_swiping_accepted(time_to_close: float) -> void:
	closing = true
	var tween: Tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property($ColorRect, "color", Color(background_color, 0.0), time_to_close)


func _on_swiping_finished() -> void:
	node_container.get_child(0).queue_free()
	visible = false
	closing = false


func _on_swiping_rejected() -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property($ColorRect, "color", Color(background_color, 0.7), 0.3)


func _on_swiping_down(percentage: float) -> void:
	$ColorRect.color = lerp(Color(background_color, 0.7), Color(background_color, 0.0), percentage)
