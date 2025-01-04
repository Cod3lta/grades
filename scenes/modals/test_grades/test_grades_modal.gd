extends Modal

var nb_questions: int = 10

var training: TestGrades.Type
var question_index: int = 0
var current_question: Control
var answers: Array
var correct: Grade
var test_resource: TestGrades
var first_try: bool

var scores: Dictionary

var grades: Array = [
	preload("res://resources/grades/adjudant-chef.tres"),
	preload("res://resources/grades/adjudant-d-etat-major.tres"),
	preload("res://resources/grades/adjudant-major.tres"),
	preload("res://resources/grades/adjudant-sous-officier.tres"),
	preload("res://resources/grades/appointe.tres"),
	preload("res://resources/grades/appointe-chef.tres"),
	preload("res://resources/grades/brigadier.tres"),
	preload("res://resources/grades/capitaine.tres"),
	preload("res://resources/grades/caporal.tres"),
	preload("res://resources/grades/colonel.tres"),
	preload("res://resources/grades/commandant-de-corps.tres"),
	preload("res://resources/grades/divisionnaire.tres"),
	preload("res://resources/grades/fourrier.tres"),
	preload("res://resources/grades/general.tres"),
	preload("res://resources/grades/lieutenant.tres"),
	preload("res://resources/grades/lieutenant-colonel.tres"),
	preload("res://resources/grades/major.tres"),
	preload("res://resources/grades/officier-specialiste.tres"),
	preload("res://resources/grades/premier-lieutenant.tres"),
	preload("res://resources/grades/sergent.tres"),
	preload("res://resources/grades/sergent-chef.tres"),
	preload("res://resources/grades/sergent-major.tres"),
	preload("res://resources/grades/sergent-major-chef.tres"),
	preload("res://resources/grades/soldat.tres"),
]

var grades_to_ask: Array = []

var tested: Dictionary = {}



func _ready() -> void:
	setup_grades_to_ask()
	next_question()


func back_request() -> void:
	pass


func get_grade_score(_correct: int, total: int) -> float:
	var ratio: float = float(_correct) / total
	return ratio * log(1 + total) + 0.5 * ratio


func setup_grades_to_ask() -> void:
	# Sort the grades array to have first the untrained, then lower to higher score
	var custom_sort: Callable = func(a, b):
		if scores.has(a) and scores.has(b):
			var score_a: float = get_grade_score(scores[a]["correct"], scores[a]["total"])
			var score_b: float = get_grade_score(scores[b]["correct"], scores[b]["total"])
			return  score_a < score_b
		else:
			return scores.has(a) < scores.has(b)
	# Shuffle to avoid alphabetical order
	grades.shuffle()
	grades.sort_custom(custom_sort)
	# If nb_questions = 10, we take the 6 first grades of the array (=the 6 with the lowest score)
	var nb_lowest_grades: int = floor(nb_questions * 2/3)
	grades_to_ask = grades.slice(0, nb_lowest_grades)
	# Then we push 4 random grades from the rest of the array
	for g in range(nb_questions - nb_lowest_grades):
		var filter: Callable = func(a):
			return a not in grades_to_ask
		var random_grade: Grade = grades.slice(nb_lowest_grades, nb_questions).filter(filter).pick_random()
		grades_to_ask.push_back(random_grade)
	grades_to_ask.shuffle()


func setup(button: Control) -> void:
	training = button.training
	scores = button.grades_score
	modal_container.set_modal_margin_top(40)
	test_resource = TestGrades.new()
	test_resource.nb_questions = nb_questions
	test_resource.trained = training
	test_resource.unix_date = Time.get_unix_time_from_system()
	tested["failed"] = []
	tested["passed"] = []
	first_try = true


func setup_question() -> void:
	$VBoxContainer/HBoxContainer/Label.text = str(question_index+1, '/', nb_questions)
	# Reset the values
	first_try = true
	current_question.reset()
	answers.clear()
	# Pick a random correct answer
	answers = [grades_to_ask.pop_front()]
	# Pick 3 random fake answers --> answers[0] is the right one
	var not_answer = func(x) -> bool:
		return x not in answers
	for i in range(3):
		answers.append(grades.filter(not_answer).pick_random())
	correct = answers[0]
	current_question.setup(answers)
	%TabContainer.current_tab = current_question.get_index()


func _on_button_pressed(index: int) -> void:
	if answers[index] != correct:
		# Answer is incorrect
		current_question.incorrect(index)
		tested["failed"].push_back(correct)
		first_try = false
	else:
		# Answer is correct
		current_question.correct(index)
		if first_try:
			tested["passed"].push_back(correct)
		question_index += 1
		await get_tree().create_timer(0.5).timeout
		if question_index >= nb_questions:
			finish_test()
		else:
			next_question()
	

func next_question() -> void:
	# Set question type
	var next: Control
	var r: bool = randi_range(0, 1)
	if training == TestGrades.Type.NAMES or training == TestGrades.Type.BOTH and not r:
		next = %GuessName
	elif training == TestGrades.Type.TEXTURES or training == TestGrades.Type.BOTH and r:
		next = %GuessTexture
	
	if current_question == null:
		current_question = next
		setup_question()
		return
	transition(next)


func finish_test() -> void:
	transition(%Results)
	test_resource.correct = tested["passed"]
	test_resource.incorrect = tested["failed"]
	%Results.set_results(test_resource)
	$VBoxContainer/HBoxContainer/CancelButton.visible = false
	# save the results on the disk
	if not DirAccess.dir_exists_absolute("user://results"):
		DirAccess.make_dir_absolute("user://results")
	var path: String = "user://results/{0}.tres".format([str(test_resource.unix_date)])
	ResourceSaver.save(test_resource, path)


func transition(next: Control) -> void:
	# Question transition animation
	%GuessContainer.add_theme_constant_override("margin_left", 0)
	%GuessContainer.add_theme_constant_override("margin_right", 0)
	%GuessContainer.add_theme_constant_override("margin_bottom", 0)
	var percentage: float = question_index / float(nb_questions)
	var difference_y : float = next.size.y - current_question.size.y
	var t: Tween = get_tree().create_tween()
	t.set_trans(Tween.TRANS_CUBIC).set_parallel()
	t.tween_property($VBoxContainer/ProgressBar, "value", percentage, 0.3)
	
	var t1: Tween = get_tree().create_tween()
	t1.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN).set_parallel()
	t1.tween_property(%GuessContainer, "theme_override_constants/margin_left", -150, 0.15)
	t1.tween_property(%GuessContainer, "theme_override_constants/margin_right", 150, 0.15)
	t.tween_property(%GuessContainer, "theme_override_constants/margin_bottom", difference_y/2, 0.15)
	t.tween_property(%GuessContainer, "modulate", Color("ffffff00"), 0.15)
	await t1.finished
	%GuessContainer.add_theme_constant_override("margin_left", 150)
	%GuessContainer.add_theme_constant_override("margin_right", -150)
	%GuessContainer.add_theme_constant_override("margin_bottom", -difference_y/2)
	current_question = next
	setup_question()
	
	var t2: Tween = get_tree().create_tween()
	t2.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT).set_parallel()
	t2.tween_property(%GuessContainer, "theme_override_constants/margin_left", 0, 0.15)
	t2.tween_property(%GuessContainer, "theme_override_constants/margin_right", 0, 0.15)
	t2.tween_property(%GuessContainer, "theme_override_constants/margin_bottom", 0, 0.15)
	t2.tween_property(%GuessContainer, "modulate", Color("ffffffff"), 0.15)
	await t2.finished


func close_test() -> void:
	modal_container.close_modal()
	if get_node("/root/App").get_page().has_method("update_results"):
		get_node("/root/App").get_page().update_results()


func _on_cancel_button_pressed() -> void:
	close_test()
