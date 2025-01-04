@tool
extends Modal

@export var epaulette: Epaulettes

func _ready() -> void:
	set_values()

func setup(button: Control) -> void:
	epaulette = button.r
	set_values()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	%Texture.set_texture(epaulette.texture_a)
	%Name.set_text(epaulette.name)
	%Incorporation.set_text(epaulette.incorporation)
