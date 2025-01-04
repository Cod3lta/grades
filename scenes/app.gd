extends Control

@onready var transition: Node3D = $Transition/TransitionViewport/Transition3D

func _ready() -> void:
	get_tree().get_root().go_back_requested.connect(go_back_requested)
	screens_changed(0)
	
	var config = ConfigFile.new()
	if FileAccess.file_exists("user://parameters.cfg"):
		config.load("user://parameters.cfg")
		TranslationServer.set_locale(config.get_value("parameters", "locale", "fr"))
	elif TranslationServer.get_all_languages().has(OS.get_locale_language()):
		TranslationServer.set_locale(OS.get_locale_language())
	else:
		TranslationServer.set_locale("fr")


func go_back_requested() -> void:
	var modal: Modal = %ModalContainer.get_modal()
	var page: Page = %PageContainer.get_page()
	if modal != null:
		modal.back_request()
	elif page != null:
		page.back_request()
	else:
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()
		#OS.shell_open("home://")


func screens_changed(index: int):
	# Reconnect the buttons on the new screen
	var buttons: Array = get_tree().get_nodes_in_group("screens_btn")
	for btn in buttons:
		btn.button_pressed.connect(show_page)
	
	# For the 3d model's animation when swiping down
	%PageSwipeDown.swiping_down.connect(%ScreenContainer.get_screen().swiping_down)
	%PageSwipeDown.swiping_rejected.connect(%ScreenContainer.get_screen().swiping_rejected)
	
	# Set the footer's button's colors
	var nav_buttons: Array = $Footer/HBoxContainer.get_children()
	for nav_btn in nav_buttons:
		nav_btn.add_theme_color_override("icon_normal_color", Color("ffffff"))
		nav_btn.add_theme_color_override("icon_hover_color", Color("ffffff"))
		nav_btn.add_theme_color_override("icon_pressed_color", Color("ffffff"))
		nav_btn.add_theme_color_override("icon_focus_color", Color("ffffff"))
	# Set current nav button's color to brown
	nav_buttons[index].add_theme_color_override("icon_normal_color", Color("7E6561"))
	nav_buttons[index].add_theme_color_override("icon_hover_color", Color("7E6561"))
	nav_buttons[index].add_theme_color_override("icon_pressed_color", Color("7E6561"))
	nav_buttons[index].add_theme_color_override("icon_focus_color", Color("7E6561"))


# TODO: Don't use the 'screenshot' method anymore, but having dedicated viewports
# for the button & page to animate so they can be displayed 'in real time' with
# ViewportTexture on the 3d meshes
# The show_page function will be moved in the PagesContainer node's script, because
# the screensContainer's screenshot won't exist anymore
func show_page(button: MainScreenButton) -> void:
	hide_footer()
	%PageContainer.margin_top = button.page_position
	
	var page_instance: Node = button.linked_page.instantiate()
	page_instance.tenue_type = button.tenue_type
	#TODO: takes too much processing time depending on the page
	%PageContainer.node_container.add_child.call_deferred(page_instance)
	
	
	button.set_visibility_layer_bit(0, false)
	$PageViewport.set_visibility_layer_bit(0, false)
	$PageViewport.visible = true
	
	await page_instance.ready
	await get_tree().process_frame
	
	# Play the animation
	transition.screen_to_page(
		button, 
		%PageContainer, 
		%PageViewport/SubViewport.get_viewport())
	
	# Connect the buttons on the new page
	var buttons: Array = get_tree().get_nodes_in_group("show_modal")
	for btn in buttons:
		btn.button_pressed.connect(show_modal)
	await transition.animation_finished
	button.set_visibility_layer_bit(0, true)
	$PageViewport.set_visibility_layer_bit(0, true)


func close_page() -> void:
	%PageSwipeDown.accept_swipe_down()


func _on_swiping_accepted(time_to_close: float) -> void:
	%ScreenContainer.get_screen().reset_soldier_camera(time_to_close)
	await get_tree().create_timer(time_to_close).timeout
	show_footer()
	$PageViewport.visible = false


func show_modal(modal_opener: Control, button: Control) -> void:
	%ModalContainer.show_modal(modal_opener, button)


func show_footer() -> void:
	var footer: Node = %Footer
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(footer, "theme_override_constants/margin_bottom", 0, 0.4)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func hide_footer() -> void:
	var footer: Node = %Footer
	var height: int = footer.get_size().y
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(footer, "theme_override_constants/margin_bottom", -height, 0.4)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)


func get_page() -> Page:
	return %PageContainer.get_page()
