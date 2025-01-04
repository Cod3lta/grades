extends VBoxContainer


func setup(grades: Array) -> void:
	$TopContainer/Name.text = grades[0].name
	grades.shuffle()
	var i: int = 0
	for c: Control in $VBoxContainer.get_children():
		c.get_child(0).r = grades[i]
		c.get_child(0).setup.call()
		i += 1


func correct(index: int) -> void:
	
	$TopContainer/LineAnimation/AnimationPlayer.play("correct")
	var grade_pressed: Control = $VBoxContainer.get_child(index).get_child(0)
	grade_pressed.modulate = Color("b0e077")


func incorrect(index: int) -> void:
	var grade_pressed: Control = $VBoxContainer.get_child(index).get_child(0)
	grade_pressed.modulate = Color("ee845f")


func reset() -> void:
	$TopContainer/LineAnimation/AnimationPlayer.play("RESET")
	for btn: Control in $VBoxContainer.get_children():
		btn.get_child(0).modulate = Color("ffffff")
