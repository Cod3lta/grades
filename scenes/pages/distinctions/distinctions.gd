@tool
extends Page

var distinctions: Array = [
	preload("res://resources/distinctions/90-jours.tres"), 
	preload("res://resources/distinctions/170-jours.tres"), 
	preload("res://resources/distinctions/250-jours.tres"), 
	preload("res://resources/distinctions/350-jours.tres"), 
	preload("res://resources/distinctions/450-jours.tres"), 
	preload("res://resources/distinctions/550-jours.tres"), 
	preload("res://resources/distinctions/650-jours.tres"), 
	preload("res://resources/distinctions/750-jours.tres"), 
	preload("res://resources/distinctions/850-jours.tres"), 
	preload("res://resources/distinctions/950-jours.tres"), 
	preload("res://resources/distinctions/prestation.tres"),
	preload("res://resources/distinctions/fass-1.tres"),
	preload("res://resources/distinctions/fass-2.tres"),
	preload("res://resources/distinctions/pistolet-1.tres"),
	preload("res://resources/distinctions/pistolet-2.tres"),
	preload("res://resources/distinctions/nbc.tres"),
	preload("res://resources/distinctions/navigateur.tres"),
	preload("res://resources/distinctions/pointeur.tres"),
	preload("res://resources/distinctions/service-croix-rouge.tres"),
	preload("res://resources/distinctions/montagne.tres"),
	preload("res://resources/distinctions/sport-1.tres"),
	preload("res://resources/distinctions/sport-2.tres"),
	preload("res://resources/distinctions/competition-sport.tres"), 
	preload("res://resources/distinctions/activite-hors-service-1.tres"), 
	preload("res://resources/distinctions/activite-hors-service-2.tres"), 
	preload("res://resources/distinctions/activite-hors-service-3.tres"), 
	preload("res://resources/distinctions/distinction-d-engagement.tres"),
	preload("res://resources/distinctions/partenariat-pour-la-paix.tres"),
	preload("res://resources/distinctions/service-longue-duree-etranger.tres"),
]

var distinction_scene = preload("res://scenes/badges/distinctions/distinction.tscn")
var distinction_modal = preload("res://scenes/modals/distinctions/distinctions_modal.tscn")
var modal_opener_scene = preload("res://scenes/pages/modal_opener.tscn")

func _ready() -> void:
	_on_disposition_changed(0)
	for distinction in distinctions:
		# Grid disposition
		var distinction_grid: Node = distinction_scene.instantiate()
		var modal_opener_grid: Node = modal_opener_scene.instantiate()
		distinction_grid.r = distinction
		modal_opener_grid.linked_modal = distinction_modal
		distinction_grid.show_text = false
		modal_opener_grid.add_child(distinction_grid)
		$VBoxContainer/GridDisposition.add_child(modal_opener_grid)
		# List disposition
		var distinction_list: Node = distinction_scene.instantiate()
		var modal_opener_list: Node = modal_opener_scene.instantiate()
		distinction_list.r = distinction
		modal_opener_list.linked_modal = distinction_modal
		distinction_list.show_text = true
		modal_opener_list.add_child(distinction_list)
		$VBoxContainer/ListDisposition.add_child(modal_opener_list)


func _on_disposition_changed(d: int) -> void:
	$VBoxContainer/GridDisposition.visible = d == 0
	$VBoxContainer/ListDisposition.visible = d == 1
