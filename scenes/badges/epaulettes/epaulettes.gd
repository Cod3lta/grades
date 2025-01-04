@tool
extends Badge

func _ready() -> void:
	texture_sizes = {
		"small": Vector2(225, 225),
		"medium": Vector2(325, 325),
		"large": Vector2(425, 425)
	}
	super._ready()
