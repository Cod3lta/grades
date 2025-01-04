@tool
extends Badge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	texture_sizes = {
		"small": Vector2(400, 160),
		"medium": Vector2(460, 186),
		"large": Vector2(520, 210)
	}
	super._ready()
