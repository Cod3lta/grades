extends Page


func _ready() -> void:
	_on_disposition_changed(0)
	#ready.emit()


func _on_disposition_changed(d: int) -> void:
	$VBoxContainer/GridDisposition.visible = d == 0
	$VBoxContainer/ListDisposition.visible = d == 1
