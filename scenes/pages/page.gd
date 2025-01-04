extends MarginContainer
class_name Page

@export_enum("A", "C") var tenue_type: String

@onready var app = get_node("/root/App")


func back_request() -> void:
	app.close_page()
