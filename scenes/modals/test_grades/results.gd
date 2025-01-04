extends MarginContainer


func setup(grades: Array) -> void:
	visible = true


func reset() -> void:
	pass


func set_results(test_resource: TestGrades) -> void:
	var points: int = test_resource.correct.size()
	$VBoxContainer/HBoxContainer/Score.text = str(points)
	$VBoxContainer/HBoxContainer/Total.text = str(test_resource.nb_questions)
	if points == test_resource.nb_questions:
		%CPUParticles1.emitting = true
		%CPUParticles2.emitting = true
