extends Page

var previous_tests: Array
var badges_score: Dictionary = {}

@export var rank_color_curve: Curve

var grade_score_scene = preload("res://scenes/pages/test_grades/grade_score.tscn")
var grade_modal_scene = preload("res://scenes/modals/grades/GradeModal.tscn")


func opening() -> void:
	update_results()


func get_grade_score(correct: int, total: int) -> float:
	var ratio: float = float(correct) / total
	return ratio * log(1 + total) + 0.5 * ratio


func update_results() -> void:
	for score in %GradeScores.get_children():
		score.queue_free()
	for result in %ResultsGrid.get_children().slice(2):
		result.queue_free()
	
	get_previous_tests()
	if previous_tests.size() > 0:
		set_result_table()
		get_grades_rank()
		set_grades_rank()
		$VBoxContainer/VBoxContainer/ModalOpener/Button2.grades_score = badges_score
		$VBoxContainer/VBoxContainer/ModalOpener2/Button2.grades_score = badges_score
		$VBoxContainer/VBoxContainer/ModalOpener3/Button2.grades_score = badges_score
		$VBoxContainer/TabContainer.current_tab = 0
	else:
		$VBoxContainer/TabContainer.current_tab = 1


func get_previous_tests() -> void:
	previous_tests.clear()
	var path: String = "user://results"
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				if file_name.get_extension() == "remap":
					file_name = file_name.replace(".remap", "")
				var file_path: String = str(path, '/', file_name)
				var result: TestGrades = load(file_path)
				previous_tests.push_back(result)
			file_name = dir.get_next()


func set_result_table() -> void:
	for test in previous_tests:
		var date: Label = Label.new()
		var progress_bar: ProgressBar = ProgressBar.new()
		
		var difference_days = int(Time.get_unix_time_from_system() - test.unix_date) / (60*60*24)
		date.text = str('il y a ', difference_days, ' jours')
		progress_bar.value = test.correct.size() * 100 / test.nb_questions
		progress_bar.show_percentage = false
		progress_bar.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		%ResultsGrid.add_child(date)
		%ResultsGrid.add_child(progress_bar)


func get_grades_rank() -> void:
	badges_score.clear()
	for test in previous_tests:
		for grade: Grade in test.correct:
			
			if not badges_score.has(grade):
				badges_score[grade] = {"total": 0, "correct": 0}
			badges_score[grade]["total"] += 1
			badges_score[grade]["correct"] += 1
		for grade in test.incorrect:
			if not badges_score.has(grade):
				badges_score[grade] = {"total": 0, "correct": 0}
			badges_score[grade]["total"] += 1


func set_grades_rank() -> void:
	var score_nodes: Array
	
	for grade: Grade in badges_score:
		# Get the nodes
		var grade_score: Control = grade_score_scene.instantiate()
		var modal_opener: Control = grade_score.get_child(0)
		var badge: Badge = modal_opener.get_child(1)
		# Set nodes parameters
		modal_opener.linked_modal = grade_modal_scene
		#btn.button_pressed.connect(show_modal)
		modal_opener.button_pressed.connect(app.show_modal)
		badge.r = grade
		
		grade_score.won = badges_score[grade]["correct"]
		grade_score.total = badges_score[grade]["total"]
		score_nodes.push_back(grade_score)
	
	# Sort the array
	var sort = func(a, b) -> bool:
		return a.get_score() < b.get_score()
	score_nodes.sort_custom(sort)
	
	var _min: float = score_nodes[0].get_score()
	var _max: float = score_nodes[score_nodes.size()-1].get_score()
	
	for s in score_nodes:
		var color: Color = Color("#959595")
		if _min < _max:
			color = lerp(Color("6976d9"), Color("95e42c"), rank_color_curve.sample(remap(s.get_score(), _min, _max, 0, 1)))
		s.get_child(1).add_theme_color_override("font_color", color)
		s.get_child(1).set_text(str(s.won, '/', s.total))
		%GradeScores.add_child(s)
