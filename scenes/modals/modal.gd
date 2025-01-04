extends MarginContainer
class_name Modal

var modal_container: Control


func setup(_button: Control) -> void:
	push_error("method not re-implemented!")


func back_request() -> void:
	modal_container.close_modal()
