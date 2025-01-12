extends GridContainer

@export_range(500, 1000, 1) var max_width: int = 800

func _ready() -> void:
	resized.connect(resize)
	await get_tree().process_frame
	resize()


func resize() -> void:
	pass#columns = clamp(floor(size.x / item_max_size), 1, 10)
