extends Node3D
class_name Soldier3D

var current_position: SpringArm3D

@export_enum("A", "C") var tenue: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_values()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	$UniformA.visible = tenue == "A"
	$UniformC.visible = tenue == "C"
	var soldier_node: Uniform3D = get_soldier_node()
	var spring_arm: SpringArm3D = soldier_node.get_spring_arm(Uniform3D.CameraPosition.DEFAULT)
	$CameraArm.position = spring_arm.position
	$CameraArm.rotation = spring_arm.rotation
	$CameraArm.spring_length = spring_arm.spring_length
	current_position = get_soldier_node().get_spring_arm(Uniform3D.CameraPosition.DEFAULT)
	


func page_opened(button: MainScreenButton, tenue: String = "A") -> void:
	#await get_tree().create_timer(0.5).timeout
	set_camera_position(button.soldier_position)


func set_camera_position(pos: Uniform3D.CameraPosition, time: float = 1) -> void:
	current_position = get_soldier_node().get_spring_arm(pos)
	time = clamp(time, 0.3, 1)
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($CameraArm, "position", current_position.position, time)
	tween.parallel().tween_property($CameraArm, "rotation", current_position.rotation, time)
	tween.parallel().tween_property($CameraArm, "spring_length", current_position.spring_length, time)


func set_camera_spring_length(amount: float, time: float, easing: Tween.EaseType = Tween.EASE_IN) -> void:
	var length: float = current_position.spring_length + max(0, amount) * 3
	if time == 0:
		$CameraArm.spring_length = length
	else:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property($CameraArm, "spring_length", length, time)
		tween.set_ease(easing).set_trans(Tween.TRANS_CUBIC)


func get_soldier_node() -> Uniform3D:
	if tenue == "A":
		return $UniformA
	elif tenue == "C":
		return $UniformC
	return $UniformA
