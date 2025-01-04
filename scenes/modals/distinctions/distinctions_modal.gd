@tool
extends Modal

@export var distinction: Distinction

func _ready() -> void:
	set_values()

func setup(button: Control) -> void:
	distinction = button.r
	set_values()

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		set_values()


func set_values() -> void:
	%Texture.set_texture(distinction.texture_a)
	%Name.set_text(distinction.name)
	%Description.set_text(distinction.description)
	%Type.set_text(get_type_name(distinction.type))


func get_type_name(t: Distinction.Type) -> String:
	match t:
		Distinction.Type.SERVICE: 
			return tr("TR_DISTINCTIONS_TYPE_SERVICE")
		Distinction.Type.DISTINCTION: 
			return tr("TR_DISTINCTIONS_TYPE_DISTINCTION")
		Distinction.Type.ENGAGEMENT: 
			return tr("TR_DISTINCTIONS_TYPE_ENGAGEMENT")
	return ""
