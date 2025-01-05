extends Screen


func open_animation() -> void:
	%OpenAnimation.add_theme_constant_override("margin_top", -80)
	%OpenAnimation.add_theme_constant_override("margin_bottom", 80)
	
	var t = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
	t.tween_property(%OpenAnimation, "theme_override_constants/margin_top", 0, 0.5)
	t.tween_property(%OpenAnimation, "theme_override_constants/margin_bottom", 0, 0.5)
