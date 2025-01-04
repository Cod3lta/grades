extends VBoxContainer


func setup(grades: Array) -> void:
	%Grade.r = grades[0]
	%Grade.setup.call()
	grades.shuffle()
	var i: int = 0
	for btn: Button in $VBoxContainer.get_children():
		btn.text = grades[i].name
		i += 1


func correct(index: int) -> void:
	$TopContainer/LineAnimation/AnimationPlayer.play("correct")
	var btn_pressed: Button = $VBoxContainer.get_child(index)
	btn_pressed.theme_type_variation = "AccGreenLightButton"


func incorrect(index: int) -> void:
	var btn_pressed: Button = $VBoxContainer.get_child(index)
	btn_pressed.theme_type_variation = "AccRedButton"


func reset() -> void:
	$TopContainer/LineAnimation/AnimationPlayer.play("RESET")
	for btn: Button in $VBoxContainer.get_children():
		btn.theme_type_variation = "ContentButton"
