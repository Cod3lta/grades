@tool
extends Badge


func _ready() -> void:
	texture_sizes = {
		"small": Vector2(300, 81),
		"medium": Vector2(400, 110),
		"large": Vector2(500, 135)
	}
	super._ready()
