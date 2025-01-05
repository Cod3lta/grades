extends MarginContainer
class_name Page

@export_enum("A", "C") var tenue_type: String:
	set(value):
		tenue_type = value
		if value != null:
			update_badges_type.emit(value)

@onready var app = get_node("/root/App")

signal update_badges_type(type: String)

func back_request() -> void:
	app.close_page()


func opening() -> void:
	pass
