extends Node3D
class_name Uniform3D

@export var soldier: Node3D
@export var start_rotation: float

func open_animation() -> void:
	var end_rotation: Vector3 = soldier.rotation
	soldier.rotation.y = end_rotation.y + start_rotation
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.tween_property(soldier, "rotation", end_rotation, 0.4)


func get_spring_arm(pos: CameraPosition) -> SpringArm3D:
	return SpringArm3D.new()


enum CameraPosition {
	DEFAULT,
	BERET,
	ARME_ET_SERVICE,
	FONCTION,
	DISTINCTION,
	EPAULETTE,
	GRADE,
	PARTICULIERS,
}
