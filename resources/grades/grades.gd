extends BadgeResource
class_name Grade

@export var short: String
@export var description: String
@export var type: Type

enum Type {
	TROUPE, 
	SOUS_OFFICIERS, 
	SOUS_OFFICIERS_SUPERIEURS, 
	OFFICIERS,
	OFFICIERS_SUPERIEURS,
	OFFICIERS_GENERAUX,
	GENERAL
}


static func get_type_name(t: Type) -> String:
	match t:
		Type.TROUPE: 
			return "TR_TROUPE"
		Type.SOUS_OFFICIERS: 
			return "TR_SOUS_OFFICIERS"
		Type.SOUS_OFFICIERS_SUPERIEURS: 
			return "TR_SOUS_OFFICIERS_SUPERIEURS"
		Type.OFFICIERS: 
			return "TR_OFFICIERS"
		Type.OFFICIERS_SUPERIEURS: 
			return "TR_OFFICIERS_SUPERIEURS"
		Type.OFFICIERS_GENERAUX: 
			return "TR_OFFICIERS_GENERAUX"
		Type.GENERAL:
			return "TR_GENERAL"
	return ""
