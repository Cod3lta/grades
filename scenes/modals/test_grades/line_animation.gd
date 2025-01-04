extends CenterContainer


func _process(_delta: float) -> void:
	$Line2D.global_position = $Control.global_position
