extends Page


func opening() -> void:
	%Francais.theme_type_variation = "AccGreenLightButton" if TranslationServer.get_locale() == "fr" else "ContentButton"
	%Deutsch.theme_type_variation = "AccGreenLightButton" if TranslationServer.get_locale() == "de" else "ContentButton"
	if DirAccess.dir_exists_absolute("user://results"):
		%DeleteData.disabled = DirAccess.open("user://results").get_files().size() == 0
	else:
		%DeleteData.disabled = true


func _on_delete_data_touch_pressed() -> void:
	var dir = DirAccess.open("user://results")
	for file in dir.get_files():
		dir.remove(file)
	%DeleteData.disabled = DirAccess.open("user://results").get_files().size() == 0


func _on_francais_touch_pressed() -> void:
	set_language("fr")
	%Francais.theme_type_variation = "AccGreenLightButton"
	%Deutsch.theme_type_variation = "ContentButton"


func _on_deutsch_touch_pressed() -> void:
	set_language("de")
	%Francais.theme_type_variation = "ContentButton"
	%Deutsch.theme_type_variation = "AccGreenLightButton"

func set_language(locale: String) -> void:
	TranslationServer.set_locale(locale)
	
	var config = ConfigFile.new()
	if FileAccess.file_exists("user://parameters.cfg"):
		config.load("user://parameters.cfg")
	config.set_value("parameters", "locale", locale)
	# Save it to a file (overwrite if already exists).
	config.save("user://parameters.cfg")
	


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
