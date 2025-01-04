extends GridContainer

@export_range(150, 1000, 1) var item_max_size: int = 450

func _ready() -> void:
	get_tree().get_root().size_changed.connect(resize)
	await get_tree().process_frame
	resize()


func resize() -> void:
	columns = clamp(floor(size.x / item_max_size), 1, 10)
