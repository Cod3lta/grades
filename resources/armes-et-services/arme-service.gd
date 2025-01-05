extends BadgeResource
class_name ArmeService

@export var type: Type

enum Type {
	COMMANDEMENT_DE_L_ARMEE, 
	ARMES, 
	SERVICES_AUXILIAIRES,
	INSIGNES_PARTICULIERS
}


static func get_type_name(t: ArmeService.Type) -> String:
	match t:
		ArmeService.Type.COMMANDEMENT_DE_L_ARMEE: 
			return "TR_ARME_SERVICE_TYPE_COMMANDEMENT_DE_L_ARMEE"
		ArmeService.Type.ARMES: 
			return "TR_ARME_SERVICE_TYPE_ARMES"
		ArmeService.Type.SERVICES_AUXILIAIRES: 
			return "TR_ARME_SERVICE_TYPE_SERVICES_AUXILIAIRES"
		ArmeService.Type.INSIGNES_PARTICULIERS: 
			return "TR_ARME_SERVICE_TYPE_INSIGNES_PARTICULIERS"
	return ""
