extends BadgeResource
class_name Distinction

@export_multiline var description: String
@export var type: Type

enum Type {
	SERVICE, 
	DISTINCTION, 
	ENGAGEMENT
}
