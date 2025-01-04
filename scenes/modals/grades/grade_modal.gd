@tool
extends Modal

@export var grade: Grade

func _ready() -> void:
	set_values()

func setup(button: Control) -> void:
	grade = button.r
	set_values()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	%TextureA.set_texture(grade.texture_a)
	%TextureC.set_texture(grade.texture_c)
	%Name.set_text(grade.name)
	%Abbr.set_text(grade.short)
	%Description.set_text(grade.description)
