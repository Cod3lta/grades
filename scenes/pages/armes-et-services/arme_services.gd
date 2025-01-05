@tool
extends Page

var arme_services: Array = [
	preload("res://resources/armes-et-services/aide-au-commandement.tres"),
	preload("res://resources/armes-et-services/artillerie.tres"),
	preload("res://resources/armes-et-services/aumonerie-chretienne.tres"),
	preload("res://resources/armes-et-services/aumonerie-juive.tres"),
	preload("res://resources/armes-et-services/aumonerie-musulmane.tres"),
	preload("res://resources/armes-et-services/croix-rouge.tres"),
	preload("res://resources/armes-et-services/dca.tres"),
	preload("res://resources/armes-et-services/defense-nbc.tres"),
	preload("res://resources/armes-et-services/disponibilite.tres"),
	preload("res://resources/armes-et-services/etat-major-general.tres"),
	preload("res://resources/armes-et-services/fanfare-militaire.tres"),
	preload("res://resources/armes-et-services/forces-aeriennes.tres"),
	preload("res://resources/armes-et-services/forces-speciales.tres"),
	preload("res://resources/armes-et-services/genie.tres"),
	preload("res://resources/armes-et-services/infanterie.tres"),
	preload("res://resources/armes-et-services/justice-militaire.tres"),
	preload("res://resources/armes-et-services/logistique.tres"),
	preload("res://resources/armes-et-services/officiers-generaux.tres"),
	preload("res://resources/armes-et-services/police-militaire.tres"),
	preload("res://resources/armes-et-services/psychopedagogique.tres"),
	preload("res://resources/armes-et-services/renseignement-militaire.tres"),
	preload("res://resources/armes-et-services/sanitaires.tres"),
	preload("res://resources/armes-et-services/sauvetage.tres"),
	preload("res://resources/armes-et-services/service-social.tres"),
	preload("res://resources/armes-et-services/sport.tres"),
	preload("res://resources/armes-et-services/territorial.tres"),
	preload("res://resources/armes-et-services/troupes-blindees.tres"),
]

var arme_service_modal = preload("res://scenes/modals/armes-et-services/armes_services_modal.tscn")
var arme_service_scene = preload("res://scenes/badges/armes-et-services/arme_service.tscn")
var modal_opener_scene = preload("res://scenes/pages/modal_opener.tscn")


func setup_type(type: ArmeService.Type, disposition: String) -> Control:
	var container : MarginContainer = MarginContainer.new()
	var vbox: VBoxContainer = VBoxContainer.new()
	var label : Label = Label.new()
	var badge_container: Control = setup_type_container(disposition)
	container.add_theme_constant_override("margin_top", 40)
	container.add_child(vbox)
	vbox.add_theme_constant_override("separation", 40)
	vbox.add_child(label)
	vbox.add_child(badge_container)
	label.text = ArmeService.get_type_name(type)
	label.theme_type_variation = "Header4"
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	for arme_service: Resource in arme_services.filter(func(x): return x.type == type):
		badge_container.add_child(setup_badge(arme_service, disposition))
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


func setup_badge(arme_service: Resource, disposition: String) -> Control:
		var badge: Badge = arme_service_scene.instantiate()
		var modal_opener: Node = modal_opener_scene.instantiate()
		badge.r = arme_service
		badge.tenue_type = tenue_type
		badge.show_text = true if disposition == "list" else false
		badge.texture_size = "small" if disposition == "list" else "medium"
		modal_opener.linked_modal = arme_service_modal
		modal_opener.add_child(badge)
		update_badges_type.connect(badge.set_type)
		return modal_opener


func _ready() -> void:
	_on_disposition_changed(0)
	
	for t in ArmeService.Type:
		$VBoxContainer/GridDisposition.add_child(setup_type(ArmeService.Type[t], "grid"))
	
	for t in ArmeService.Type:
		$VBoxContainer/ListDisposition.add_child(setup_type(ArmeService.Type[t], "list"))


func _on_disposition_changed(d: int) -> void:
	$VBoxContainer/GridDisposition.visible = d == 0
	$VBoxContainer/ListDisposition.visible = d == 1
