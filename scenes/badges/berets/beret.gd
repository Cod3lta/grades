@tool
extends Badge

func _ready() -> void:
	texture_sizes = {
		"small": Vector2(270, 115),
		"medium": Vector2(350, 150),
		"large": Vector2(420, 180)
	}
	super._ready()
