@tool
extends Modal

@export var fonction: Fonction

func _ready() -> void:
	set_values()

func setup(button: Control) -> void:
	fonction = button.r
	set_values()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	%TextureA.set_texture(fonction.texture_a)
	%TextureC.set_texture(fonction.texture_c)
	%Name.set_text(fonction.name)
