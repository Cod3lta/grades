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

func _ready() -> void:
	_on_disposition_changed(0)
	for arme_service in arme_services:
		# Grid disposition
		var arme_service_grid: Badge = arme_service_scene.instantiate()
		var modal_opener_grid: Node = modal_opener_scene.instantiate()
		arme_service_grid.r = arme_service
		arme_service_grid.tenue_type = tenue_type
		arme_service_grid.show_text = false
		modal_opener_grid.linked_modal = arme_service_modal
		modal_opener_grid.add_child(arme_service_grid)
		$VBoxContainer/GridDisposition.add_child(modal_opener_grid)
		# List disposition
		var arme_service_list: Badge = arme_service_scene.instantiate()
		var modal_opener_list: Node = modal_opener_scene.instantiate()
		arme_service_list.r = arme_service
		arme_service_list.texture_size = "small"
		arme_service_list.tenue_type = tenue_type
		arme_service_list.show_text = true
		modal_opener_list.linked_modal = arme_service_modal
		modal_opener_list.add_child(arme_service_list)
		$VBoxContainer/ListDisposition.add_child(modal_opener_list)


func _on_disposition_changed(d: int) -> void:
	$VBoxContainer/GridDisposition.visible = d == 0
	$VBoxContainer/ListDisposition.visible = d == 1
