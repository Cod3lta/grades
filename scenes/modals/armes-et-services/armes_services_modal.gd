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
	%Type.set_text(get_type_name(arme_service.type))


func get_type_name(t: ArmeService.Type) -> String:
	match t:
		ArmeService.Type.COMMANDEMENT_DE_L_ARMEE: 
			return tr("TR_ARME_SERVICE_TYPE_COMMANDEMENT_DE_L_ARMEE")
		ArmeService.Type.ARMES: 
			return tr("TR_ARME_SERVICE_TYPE_ARMES")
		ArmeService.Type.SERVICES_AUXILIAIRES: 
			return tr("TR_ARME_SERVICE_TYPE_SERVICES_AUXILIAIRES")
		ArmeService.Type.INSIGNES_PARTICULIERS: 
			return tr("TR_ARME_SERVICE_TYPE_INSIGNES_PARTICULIERS")
	return ""
