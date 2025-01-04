extends VBoxContainer

@export var won: int
@export var total: int
#@export var score: float

func get_score() -> float:
	var ratio: float = float(won) / total
	return ratio * log(1 + total) + 0.5 * ratio
