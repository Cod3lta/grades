@tool
extends MarginContainer
class_name Badge

@export_enum("A", "C") var tenue_type: String
@export_enum("small", "medium", "large") var texture_size = "medium"

@export var r: Resource
@export var name_label: Label
@export var texture_rect_a: TextureRect
@export var texture_rect_c: TextureRect
@export var show_text: bool = false
@export var text_container: Control


# Default values for a badge size
var texture_sizes: Dictionary = {
	"small": Vector2(200, 200),
	"medium": Vector2(300, 300),
	"large": Vector2(400, 400)
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		update()


func set_type(type : String) -> void:
	tenue_type = type
	update()


# Setup the common values of the badge (textures, name, size, show_text)
func update() -> void:
	# Textures
	if tenue_type == "A" and texture_rect_a:
		texture_rect_a.set_texture(r.texture_a)
		texture_rect_a.set_custom_minimum_size(texture_sizes[texture_size])
	elif tenue_type == "C" and texture_rect_c:
		texture_rect_c.set_texture(r.texture_c)
		texture_rect_c.set_custom_minimum_size(texture_sizes[texture_size])
	# Name
	if name_label:
		name_label.text = r.name
	# Show text
	if text_container:
		text_container.visible = show_text
