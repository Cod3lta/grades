@tool
extends Page

var epaulettes: Array = [
	preload("res://resources/epaulettes/aide-au-commandement.tres"),
	preload("res://resources/epaulettes/artillerie.tres"),
	preload("res://resources/epaulettes/forces-aeriennes.tres"),
	preload("res://resources/epaulettes/forces-speciales.tres"),
	preload("res://resources/epaulettes/infanterie.tres"),
	preload("res://resources/epaulettes/justice-militaire.tres"),
	preload("res://resources/epaulettes/logistique.tres"),
	preload("res://resources/epaulettes/nbc.tres"),
	preload("res://resources/epaulettes/noir.tres"),
	preload("res://resources/epaulettes/onu.tres"),
	preload("res://resources/epaulettes/police-militaire.tres"),
	preload("res://resources/epaulettes/sanitaire.tres"),
	preload("res://resources/epaulettes/sauvetage.tres"),
	preload("res://resources/epaulettes/territorial.tres"),
	preload("res://resources/epaulettes/troupes-blindees.tres"),
]

var epaulettes_modal = preload("res://scenes/modals/epaulettes/epaulettes_modal.tscn")
var epaulettes_scene = preload("res://scenes/badges/epaulettes/epaulettes.tscn")
var modal_opener_scene = preload("res://scenes/pages/modal_opener.tscn")

func _ready() -> void:
	for epaulette in epaulettes:
		var epaulette_node: Node = epaulettes_scene.instantiate()
		var modal_opener: Node = modal_opener_scene.instantiate()
		epaulette_node.r = epaulette
		modal_opener.linked_modal = epaulettes_modal
		modal_opener.add_child(epaulette_node)
		$VBoxContainer/EpaulettesContainer.add_child(modal_opener)
