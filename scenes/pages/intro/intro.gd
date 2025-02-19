extends Page


func opening() -> void:
	%Francais.theme_type_variation = "AccGreenLightButton" if TranslationServer.get_locale() == "fr" else "ContentButton"
	%Deutsch.theme_type_variation = "AccGreenLightButton" if TranslationServer.get_locale() == "de" else "ContentButton"
	


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
	
	# Create new ConfigFile object.
	var config = ConfigFile.new()
	if FileAccess.file_exists("user://parameters.cfg"):
		config.load("user://parameters.cfg")
	config.set_value("parameters", "locale", locale)
	# Save it to a file (overwrite if already exists).
	config.save("user://parameters.cfg")
	


func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	OS.shell_open(str(meta))
