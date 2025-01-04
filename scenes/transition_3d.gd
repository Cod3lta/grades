extends Node3D

@onready var button_mesh: MeshInstance3D = $ButtonMesh
@onready var page_mesh: MeshInstance3D = $PageMesh

signal animation_finished

func screen_to_page(
	button: Control, 
	page_container: Control, 
	page_viewport: Viewport) -> void:
	
	button_mesh.get_material_override().set_texture(BaseMaterial3D.TEXTURE_ALBEDO, button.get_button_viewport().get_texture())
	page_mesh.get_material_override().set_texture(BaseMaterial3D.TEXTURE_ALBEDO, page_viewport.get_texture())
	
	# sometimes the animation doesn't go to the right place?
	await get_tree().process_frame
	await get_tree().process_frame 
	
	"""
	Here we have 2 coordinates systems: one in 2d (the UI)
	and one in 3d (the 3d world made for the animation)
	1st we need to find the meshes's position and size 
	in the 2d system, then translate them in 3d
	
	button              page
	a--------------+	a--------------+	a: 3d point of top left
	|              |	|              |	b: 3d point of bottom right
	|              |	| <----h-----> |	c: 3d point of center of ButtonMesh
	|  d-----+     |	|              |	f: 3d point of center of PageMesh
	|  |  c  |     |	| g----------+ |	e: size of button
	|  +-----+     |	| |          | |	b: 2d point of screen size
	|              |	| |    f     | |	d: 2d point of button position
	|  <--e-->     |	| |          | |	g: 2d point of page position
	|              |	| +----------+ |	h: size of page
	+--------------b	+--------------b
	
	note: The page's position & size are overflowing outside
	the screen, so they must be trimmed (clamp()) first
	
	"""
	
	# Get the values in the 2d coordinate system
	var viewport: Viewport = get_viewport()
	var viewport_size: Vector2 = viewport.get_visible_rect().size # b
	var btn_position: Vector2 = button.get_global_position() # d
	var btn_size: Vector2 = button.get_size() # e
	var btn_center: Vector2 = btn_position + btn_size/2
	var page_position: Vector2 = page_container.get_panel().get_global_position().clamp(Vector2.ZERO, viewport_size) # g
	var page_size: Vector2 = page_container.get_panel().get_size().clamp(Vector2.ZERO, viewport_size - page_position) # h
	var page_center: Vector2 = page_position + page_size/2
	var top_left: Vector3 = $Camera3D.project_position(Vector2.ZERO, 5) # a
	var bottom_right: Vector3 = $Camera3D.project_position(viewport_size, 5) # b
	
	# Calculate the starting size & position of the meshes
	var start_position: Vector3 = Vector3(lerpf(top_left.x, bottom_right.x, btn_center.x / viewport_size.x), 0, lerpf(top_left.z, bottom_right.z, btn_center.y / viewport_size.y)) # c
	var start_size: Vector2 = Vector2(lerpf(0, bottom_right.x*2, btn_size.x / viewport_size.x), lerpf(0, bottom_right.z*2, btn_size.y / viewport_size.y))
	
	# Calculate the ending size & position of the meshes
	var end_position: Vector3 = Vector3(lerpf(top_left.x, bottom_right.x, page_center.x / viewport_size.x), 0, lerpf(top_left.z, bottom_right.z, page_center.y / viewport_size.y)) # f
	var end_size: Vector2 = Vector2(lerpf(0, bottom_right.x*2, page_size.x / viewport_size.x), lerpf(0, bottom_right.z*2, page_size.y / viewport_size.y))
	# bottom_right*2 because top_right has negative x and z
	
	# Set the starting positions
	button_mesh.position = start_position
	button_mesh.mesh.set_size(start_size)
	page_mesh.position = start_position
	page_mesh.mesh.set_size(start_size)
	
	# Set the offset & UV scale to get the page meshe's textures covering it
	page_mesh.get_material_override().set_uv1_offset(Vector3(page_position.x / viewport_size.x, page_position.y / viewport_size.y, 0.0))
	page_mesh.get_material_override().set_uv1_scale(Vector3(page_size.x / viewport_size.x, page_size.y / viewport_size.y, 0.0))
	
	
	# Animate the meshes
	button_mesh.set_layer_mask_value(1, true)
	page_mesh.set_layer_mask_value(1, true)
	button_mesh.rotation = Vector3(0, 0, 0)
	page_mesh.rotation = Vector3(0, 0, -PI)
	
	var d: float = 0.5
	var tween: Tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(button_mesh, "rotation", Vector3(0, 0, PI), d)
	tween.parallel().tween_property(button_mesh, "position", end_position, d)
	tween.parallel().tween_property(button_mesh.mesh, "size", end_size, d)
	tween.parallel().tween_property(page_mesh, "rotation", Vector3(0, 0, 0), d)
	tween.parallel().tween_property(page_mesh, "position", end_position, d)
	tween.parallel().tween_property(page_mesh.mesh, "size", end_size, d)
	
	await tween.finished
	button_mesh.set_layer_mask_value(1, false)
	page_mesh.set_layer_mask_value(1, false)
	animation_finished.emit()


func page_to_modal(
	button: Control, 
	_modal_container: Control) -> void:
	
	button_mesh.get_material_override().set_texture(BaseMaterial3D.TEXTURE_ALBEDO, button.get_button_viewport().get_texture())
	pass
