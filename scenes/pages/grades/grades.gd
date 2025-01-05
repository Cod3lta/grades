@tool
extends Page

var grades: Array = [
	preload("res://resources/grades/recrue.tres"),
	preload("res://resources/grades/soldat.tres"),
	preload("res://resources/grades/appointe.tres"),
	preload("res://resources/grades/appointe-chef.tres"),
	preload("res://resources/grades/caporal.tres"),
	preload("res://resources/grades/sergent.tres"),
	preload("res://resources/grades/sergent-chef.tres"),
	preload("res://resources/grades/sergent-major.tres"),
	preload("res://resources/grades/fourrier.tres"),
	preload("res://resources/grades/sergent-major-chef.tres"),
	preload("res://resources/grades/adjudant-sous-officier.tres"),
	preload("res://resources/grades/adjudant-d-etat-major.tres"),
	preload("res://resources/grades/adjudant-major.tres"),
	preload("res://resources/grades/adjudant-chef.tres"),
	preload("res://resources/grades/lieutenant.tres"),
	preload("res://resources/grades/premier-lieutenant.tres"),
	preload("res://resources/grades/capitaine.tres"),
	preload("res://resources/grades/major.tres"),
	preload("res://resources/grades/lieutenant-colonel.tres"),
	preload("res://resources/grades/colonel.tres"),
	preload("res://resources/grades/officier-specialiste.tres"),
	preload("res://resources/grades/brigadier.tres"),
	preload("res://resources/grades/divisionnaire.tres"),
	preload("res://resources/grades/commandant-de-corps.tres"),
	preload("res://resources/grades/general.tres"),
	
]

var grade_modal = preload("res://scenes/modals/grades/GradeModal.tscn")
var grade_scene = preload("res://scenes/badges/grade/grade.tscn")
var modal_opener_scene = preload("res://scenes/pages/modal_opener.tscn")


func _ready() -> void:
	_on_disposition_changed(0)
	
	for t in Grade.Type:
		$VBoxContainer/GridDisposition.add_child(setup_type(Grade.Type[t], "grid"))
	
	for t in Grade.Type:
		$VBoxContainer/ListDisposition.add_child(setup_type(Grade.Type[t], "list"))


func setup_type(type: Grade.Type, disposition: String) -> Control:
	var container : MarginContainer = MarginContainer.new()
	var vbox: VBoxContainer = VBoxContainer.new()
	var label : Label = Label.new()
	var badge_container: Control = setup_type_container(disposition)
	container.add_theme_constant_override("margin_top", 40)
	container.add_child(vbox)
	vbox.add_theme_constant_override("separation", 40)
	vbox.add_child(label)
	vbox.add_child(badge_container)
	label.text = Grade.get_type_name(type)
	label.theme_type_variation = "Header4"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for grade: Resource in grades.filter(func(x): return x.type == type):
		badge_container.add_child(setup_badge(grade, disposition))
	return container


func setup_type_container(disposition: String) -> Control:
	if disposition == "grid":
		var container : HFlowContainer = HFlowContainer.new()
		container.alignment = FlowContainer.ALIGNMENT_CENTER
		container.last_wrap_alignment = FlowContainer.LAST_WRAP_ALIGNMENT_BEGIN
		container.add_theme_constant_override("h_separation", 60)
		container.add_theme_constant_override("v_separation", 60)
		return container
	elif disposition == "list":
		var container : VBoxContainer = VBoxContainer.new()
		container.add_theme_constant_override("separation", 60)
		return container
	return null


func setup_badge(grade: Resource, disposition: String) -> Control:
		var badge: Badge = grade_scene.instantiate()
		var modal_opener: Node = modal_opener_scene.instantiate()
		badge.r = grade
		badge.tenue_type = tenue_type
		badge.show_text = true if disposition == "list" else false
		badge.texture_size = "small" if disposition == "list" else "medium"
		modal_opener.linked_modal = grade_modal
		modal_opener.add_child(badge)
		update_badges_type.connect(badge.set_type)
		return modal_opener


func _on_disposition_changed(d: int) -> void:
	$VBoxContainer/GridDisposition.visible = d == 0
	$VBoxContainer/ListDisposition.visible = d == 1
