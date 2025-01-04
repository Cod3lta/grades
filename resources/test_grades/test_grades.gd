extends Resource
class_name TestGrades

@export var unix_date: int
@export var trained: Type
@export var nb_questions: int
@export var correct: Array
@export var incorrect: Array

enum Type {
	TEXTURES,
	NAMES,
	BOTH
}
