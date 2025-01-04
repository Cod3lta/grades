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
