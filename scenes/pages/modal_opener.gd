extends Control

@export var linked_modal: PackedScene
@export var dismissable: bool = true

signal button_pressed(linked_modal: PackedScene, insigne: Control)


func _ready() -> void:
	# Move the button above the other node
	move_child($Button, get_child_count() - 1)


func _on_button_pressed() -> void:
	button_pressed.emit(self, get_child(0))
