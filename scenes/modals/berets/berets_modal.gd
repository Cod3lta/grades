@tool
extends Modal

@export var beret: Beret

func _ready() -> void:
	set_values()

func setup(button: Control) -> void:
	beret = button.r
	set_values()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	%Texture.set_texture(beret.texture_a)
	%Name.set_text(beret.name)
	%Incorporation.set_text(beret.incorporation)
