extends HBoxContainer

@export var pressed: DISPOSITIONS 
signal disposition_changed(d: DISPOSITIONS)

# Same order as in tree
enum DISPOSITIONS {
	GRID,
	LIST
}

func _ready() -> void:
	set_buttons_pressed()


func set_buttons_pressed() -> void:
	for btn: Button in get_children():
		var is_pressed: bool = btn.get_index() == pressed
		btn.button_pressed = is_pressed



func _on_button_pressed(index: int) -> void:
	pressed = index as DISPOSITIONS
	disposition_changed.emit(index)
	set_buttons_pressed()
