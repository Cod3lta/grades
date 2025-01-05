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

	var buttons_open_page: Array = get_tree().get_nodes_in_group("show_page")
	for btn in buttons_open_page:
		btn.button_pressed.connect(show_page)
	
	var buttons_open_modal: Array = get_tree().get_nodes_in_group("show_modal")
	for btn in buttons_open_modal:
		btn.button_pressed.connect(show_modal)
	
	# For the 3d model's animation when swiping down
	for screen: Screen in %ScreenContainer.node_container.get_children():
		%PageSwipeDown.swiping_down.connect(screen.swiping_down)
		%PageSwipeDown.swiping_rejected.connect(screen.swiping_rejected)

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
	
	%ScreenContainer.get_screen().open_animation()
	

# TODO: Don't use the 'screenshot' method anymore, but having dedicated viewports
# for the button & page to animate so they can be displayed 'in real time' with
# ViewportTexture on the 3d meshes
# The show_page function will be moved in the PagesContainer node's script, because
# the screensContainer's screenshot won't exist anymore
func show_page(button: MainScreenButton) -> void:
	hide_footer()
	%PageContainer.margin_top = button.page_position
	%PageContainer.scroll_vertical = 0
	
	var page: Page = %PageContainer.get_page_by_scene(button.linked_page_name)
	page.opening()
	page.tenue_type = button.tenue_type
	%PageContainer.node_container.current_tab = page.get_index()
	
	# Play the animation
	button.set_visibility_layer_bit(0, false)
	$PageViewport.set_visibility_layer_bit(0, false)
	$PageViewport.visible = true
	transition.screen_to_page(
		button, 
		%PageContainer, 
		%PageViewport/SubViewport.get_viewport())
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
