@tool
extends Badge


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_sizes = {
		"small": Vector2(250, 200),
		"medium": Vector2(350, 300),
		"large": Vector2(450, 400)
	}
	super._ready()
