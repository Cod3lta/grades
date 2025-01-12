extends Control

@onready var transition: Node3D = $Transition/TransitionViewport/Transition3D

# Count the amount of page or modal currently open
# Can be either 0, 1 or 2
# Used to hide or show the footer when the var changes betweeen 0 and 1
var page_depth: int = 0:
	set(value):
		page_depth = clampi(value, 0, 10)

func _ready() -> void:
	get_tree().get_root().go_back_requested.connect(go_back_requested)
	screens_changed(0)
	
	# Set the language
	var config = ConfigFile.new()
	if FileAccess.file_exists("user://parameters.cfg"):
		config.load("user://parameters.cfg")
		TranslationServer.set_locale(config.get_value("parameters", "locale", "fr"))
	elif TranslationServer.get_all_languages().has(OS.get_locale_language()):
		TranslationServer.set_locale(OS.get_locale_language())
	else:
		TranslationServer.set_locale("fr")
	
	# Connect buttons to open pages
	var buttons_open_page: Array = get_tree().get_nodes_in_group("show_page")
	for btn in buttons_open_page:
		btn.button_pressed.connect(show_page)
	
	# Connect buttons to open modals
	var buttons_open_modal: Array = get_tree().get_nodes_in_group("show_modal")
	for btn in buttons_open_modal:
		btn.button_pressed.connect(show_modal)
	
	# For the 3d model's animation when swiping down
	for screen: Screen in %ScreenContainer.node_container.get_children():
		%PageSwipeDown.swiping_down.connect(screen.swiping_down)
		%PageSwipeDown.swiping_rejected.connect(screen.swiping_rejected)
	
	# Show intro page
	var intro_seen: bool = config.get_value("parameters", "intro_seen", false)
	if not intro_seen:
		# Show the intro page, hide the footer (without animation)
		var page: Page = %PageContainer.get_page_by_scene("Intro")
		%PageContainer.node_container.current_tab = page.get_index()
		%PageSwipeDown.dismissable = false
		$PageViewport.visible = true
		%PageContainer.get_node("PageMargin/PanelContainer/VBoxContainer/MarginContainer/DownArrow").visible = false
		var height: int = %Footer.get_size().y
		page_depth = 1
		%Footer.add_theme_constant_override("margin_bottom", %Footer.get_size().y * -1)
		config.set_value("parameters", "intro_seen", true)
		config.save("user://parameters.cfg")


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
	var nav_buttons: Array = $Footer/MarginContainer/HBoxContainer.get_children()
	for nav_btn in nav_buttons:
		var img: TextureRect = nav_btn.get_node("VBoxContainer/TextureRect")
		img.modulate = Color("#ffffff")
	# Set current nav button's color to brown
	nav_buttons[index].get_node("VBoxContainer/TextureRect").modulate = Color("#729841")
	
	%ScreenContainer.get_screen().open_animation()
	

# TODO: Don't use the 'screenshot' method anymore, but having dedicated viewports
# for the button & page to animate so they can be displayed 'in real time' with
# ViewportTexture on the 3d meshes
# The show_page function will be moved in the PagesContainer node's script, because
# the screensContainer's screenshot won't exist anymore
func show_page(button: MainScreenButton) -> void:
	hide_footer()
	%PageSwipeDown.dismissable = true
	%PageContainer.get_node("PageMargin/PanelContainer/VBoxContainer/MarginContainer/DownArrow").visible = true
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


func _on_swiping_accepted(time_to_close: float) -> void:
	%ScreenContainer.get_screen().reset_soldier_camera(time_to_close)
	await get_tree().create_timer(time_to_close).timeout
	$PageViewport.visible = false
	show_footer()


func show_modal(modal_opener: Control, button: Control) -> void:
	%ModalContainer.show_modal(modal_opener, button)
	hide_footer()


func _on_modal_swipe_down_swiping_accepted(time_to_close: float) -> void:
	show_footer()


func show_footer() -> void:
	page_depth -= 1
	if page_depth == 0:
		var footer: Node = %Footer
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(footer, "theme_override_constants/margin_bottom", 0, 0.4)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func hide_footer() -> void:
	page_depth += 1
	if page_depth == 1:
		var footer: Node = %Footer
		var height: int = footer.get_size().y
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(footer, "theme_override_constants/margin_bottom", -height, 0.4)\
			.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)


# Called by the current page in case of a back_request
func close_page() -> void:
	%PageSwipeDown.accept_swipe_down()


func get_page() -> Page:
	return %PageContainer.get_page()
