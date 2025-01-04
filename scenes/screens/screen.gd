extends MarginContainer
class_name Screen

@export var soldier_scene: Soldier3D
@export_enum("A", "C") var tenue: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if soldier_scene:
		var buttons: Array = get_tree().get_nodes_in_group("screens_btn")
		for btn: MainScreenButton in buttons:
			btn.button_pressed.connect(soldier_scene.page_opened.bind(tenue))


func reset_soldier_camera(time: float) -> void:
	if soldier_scene:
		soldier_scene.set_camera_position(Uniform3D.CameraPosition.DEFAULT, time)


func swiping_down(percentage: float) -> void:
	if soldier_scene:
		soldier_scene.set_camera_spring_length(percentage, 0)


func swiping_rejected() -> void:
	if soldier_scene:
		soldier_scene.set_camera_spring_length(0, 0.3)
