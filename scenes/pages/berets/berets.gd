@tool
extends Page

var berets: Array = [
	preload("res://resources/berets/artillerie.tres"),
	preload("res://resources/berets/forces-aeriennes.tres"),
	preload("res://resources/berets/forces-speciales.tres"),
	preload("res://resources/berets/infanterie.tres"),
	preload("res://resources/berets/logistique.tres"),
	preload("res://resources/berets/noir.tres"),
	preload("res://resources/berets/onu.tres"),
	preload("res://resources/berets/police-militaire.tres"),
	preload("res://resources/berets/sanitaire.tres"),
]

var beret_modal = preload("res://scenes/modals/berets/berets_modal.tscn")
var beret_scene = preload("res://scenes/badges/berets/beret.tscn")
var modal_opener_scene = preload("res://scenes/pages/modal_opener.tscn")

func _ready() -> void:
	for beret in berets:
		var beret_node: Badge = beret_scene.instantiate()
		var modal_opener: Node = modal_opener_scene.instantiate()
		beret_node.r = beret
		modal_opener.linked_modal = beret_modal
		update_badges_type.connect(beret_node.set_type)
		modal_opener.add_child(beret_node)
		$VBoxContainer/BeretsContainer.add_child(modal_opener)
