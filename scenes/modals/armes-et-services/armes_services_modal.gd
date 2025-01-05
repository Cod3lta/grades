@tool
extends Modal

@export var arme_service: ArmeService

func _ready() -> void:
	set_values()

func setup(button: Control) -> void:
	arme_service = button.r
	set_values()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	%TextureA.set_texture(arme_service.texture_a)
	%TextureC.set_texture(arme_service.texture_c)
	%Name.set_text(arme_service.name)
	%Type.set_text(tr(ArmeService.get_type_name(arme_service.type)))
