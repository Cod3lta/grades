@tool

extends MarginContainer
class_name MainScreenButton

@export var text: String
@export var style: ButtonColor = ButtonColor.DEFAULT
@export var soldier_position: Uniform3D.CameraPosition = Uniform3D.CameraPosition.DEFAULT
@export_enum("A", "C") var tenue_type: String = "A"
@export_category("page")
#@export var linked_page: PackedScene
@export var linked_page_name: String
@export var page_position: PagePosition
@export_category("Background image")
@export var background_image: Texture2D
@export var background_image_size: float = 0.35
@export var background_image_position: Vector2 = Vector2(-35, 0)


enum PagePosition {
	TOP,
	MIDDLE
}

enum ButtonColor {
	DEFAULT,
	GREEN
}

signal button_pressed

func _ready() -> void:
	setup_button()
	size_button()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		setup_button()
	size_button()


func get_button_viewport() -> SubViewport:
	return $SubViewportContainer/SubViewport


func size_button() -> void:
	custom_minimum_size.y = size.x
	size.y = size.x
	%BackgroundImage.size = %BackgroundImage.texture.get_size() * background_image_size * size.x / 100
	%BackgroundImage.position = size / 2 + background_image_position * size / 100 - %BackgroundImage.size / 2


func setup_button() -> void:
	custom_minimum_size.y = size.x
	size.y = size.x
	%Label.text = text
	%BackgroundImage.texture = background_image
	%Button.theme_type_variation = get_button_type_variation()
	var shader: ShaderMaterial = %BackgroundImage.material
	var icon_color: Color = get_icon_color()
	shader.set_shader_parameter("color", Vector3(icon_color.r, icon_color.g, icon_color.b))
	if background_image:
		shader.set_shader_parameter("image", background_image)


func get_icon_color() -> Color:
	match style:
		ButtonColor.DEFAULT:
			return get_theme_color("icon_normal_color", "Button")
		ButtonColor.GREEN:
			return get_theme_color("icon_normal_color", "AccGreenLightButton")
	return Color.BLACK


func get_button_type_variation() -> String:
	match style:
		ButtonColor.DEFAULT:
			return "Button"
		ButtonColor.GREEN:
			return "AccGreenLightButton"
	return "Button"


func _on_button_pressed() -> void:
	button_pressed.emit(self)
