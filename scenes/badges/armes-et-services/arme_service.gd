@tool
extends Badge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	texture_sizes = {
		"small": Vector2(150, 300),
		"medium": Vector2(200, 400),
		"large": Vector2(250, 500)
	}
	super._ready()
