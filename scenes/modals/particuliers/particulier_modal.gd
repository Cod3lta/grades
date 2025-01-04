@tool
extends Modal

@export var particulier: Particulier

func _ready() -> void:
	set_values()

func setup(button: Control) -> void:
	particulier = button.r
	set_values()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	%TextureC.set_texture(particulier.texture_c)
	%Name.set_text(particulier.name)
