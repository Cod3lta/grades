extends ScrollContainer

@export var node_container: Node

var closing: bool = false

var margin_top: int = 0: 
	set(value):
		if value == MainScreenButton.PagePosition.TOP:
			margin_top = 40
		elif value == MainScreenButton.PagePosition.MIDDLE:
			margin_top = 850
		%PageMargin.add_theme_constant_override("margin_top", margin_top)


func get_page() -> Page:
	if node_container.get_child_count() > 0 and not closing:
		return node_container.get_child(0)
	return null


func get_page_by_scene(scene: String) -> Page:
	for node in node_container.get_children():
		if node.name == scene:
			return node
	return null


# Used in the 3d animation to open a page
func get_panel() -> PanelContainer:
	return $PageMargin/PanelContainer


func get_viewport_container() -> SubViewportContainer:
	return get_parent().get_parent()


func _on_swiping_accepted(_time_to_close: float) -> void:
	closing = true


func _on_swiping_finished() -> void:
	#node_container.get_child(0).queue_free()
	closing = false


func _on_down_arrow_pressed() -> void:
	get_parent().accept_swipe_down()
