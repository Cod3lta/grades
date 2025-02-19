@tool
extends Page

var fonctions: Array = [
	preload("res://resources/fonction/armurier.tres"),
	preload("res://resources/fonction/auditeur.tres"),
	preload("res://resources/fonction/aumonier-chef-de-service.tres"),
	preload("res://resources/fonction/automobiliste.tres"),
	preload("res://resources/fonction/batteur.tres"),
	preload("res://resources/fonction/cannonier.tres"),
	preload("res://resources/fonction/cannonier-dca.tres"),
	preload("res://resources/fonction/canonnier-lance-mines.tres"),
	preload("res://resources/fonction/compagnie-de-maintenance-aviation.tres"),
	preload("res://resources/fonction/compagnie-de-support-de-transport-aerien.tres"),
	preload("res://resources/fonction/compagnie-de-transport-aerien-escadrille-de-transport-aerien.tres"),
	preload("res://resources/fonction/compagnie-etat-major-aerodrome.tres"),
	preload("res://resources/fonction/compagnie-logistique-de-transport-aerien.tres"),
	preload("res://resources/fonction/comptable-de-troupe.tres"),
	preload("res://resources/fonction/conducteur-de-chien.tres"),
	preload("res://resources/fonction/conducteur-de-machine-de-chantier.tres"),
	preload("res://resources/fonction/conseiller-social.tres"),
	preload("res://resources/fonction/cuisinier-de-troupe.tres"),
	preload("res://resources/fonction/detachement-d-exploration-de-larmee.tres"),
	preload("res://resources/fonction/eclaireur.tres"),
	preload("res://resources/fonction/eclaireur-parachutiste.tres"),
	preload("res://resources/fonction/escadre-d-aviation.tres"),
	preload("res://resources/fonction/escadre-de-drone.tres"),
	preload("res://resources/fonction/explorateur-radio.tres"),
	preload("res://resources/fonction/explorateur-radio-strategique.tres"),
	preload("res://resources/fonction/fantassin.tres"),
	preload("res://resources/fonction/fantassin-equipier-conducteur-char-infanterie.tres"),
	preload("res://resources/fonction/fusilier-de-bord.tres"),
	preload("res://resources/fonction/greffier-de-tribunal.tres"),
	preload("res://resources/fonction/grenadier.tres"),
	preload("res://resources/fonction/grenadier-de-la-police-militaire.tres"),
	preload("res://resources/fonction/grenadier-forces-speciales.tres"),
	preload("res://resources/fonction/juge-d-instruction.tres"),
	preload("res://resources/fonction/justice-militaire.tres"),
	preload("res://resources/fonction/kokamir.tres"),
	preload("res://resources/fonction/marechal-ferrant.tres"),
	preload("res://resources/fonction/mecanicien-sur-appareils.tres"),
	preload("res://resources/fonction/mecanicien-sur-appareils-acfa.tres"),
	preload("res://resources/fonction/mecanicien-sur-chars.tres"),
	preload("res://resources/fonction/mecanicien-sur-moteurs.tres"),
	preload("res://resources/fonction/ordonnance-d-officier.tres"),
	preload("res://resources/fonction/ordonnance-de-bureau.tres"),
	preload("res://resources/fonction/pionnier-constructeur.tres"),
	preload("res://resources/fonction/pionnier-d-ondes-dirigees.tres"),
	preload("res://resources/fonction/pionnier-informatique.tres"),
	preload("res://resources/fonction/pontonnier.tres"),
	preload("res://resources/fonction/pontonnier-de-sonnettes.tres"),
	preload("res://resources/fonction/poste-de-campagne.tres"),
	preload("res://resources/fonction/prepose-aux-engins-de-sauvetage.tres"),
	preload("res://resources/fonction/president.tres"),
	preload("res://resources/fonction/sapeur.tres"),
	preload("res://resources/fonction/sapeur-de-base-aerienne.tres"),
	preload("res://resources/fonction/sapeur-de-chars.tres"),
	preload("res://resources/fonction/secretaire.tres"),
	preload("res://resources/fonction/soldat-acfa.tres"),
	preload("res://resources/fonction/soldat-d-aviation.tres"),
	preload("res://resources/fonction/soldat-d-echelon-de-conduite.tres"),
	preload("res://resources/fonction/soldat-d-engin-guide-rapier.tres"),
	preload("res://resources/fonction/soldat-d-engin-guide-stinger.tres"),
	preload("res://resources/fonction/soldat-d-exploitation.tres"),
	preload("res://resources/fonction/soldat-d-exploration.tres"),
	preload("res://resources/fonction/soldat-d-hopital.tres"),
	preload("res://resources/fonction/soldat-de-chars.tres"),
	preload("res://resources/fonction/soldat-de-chasseur-de-chars.tres"),
	preload("res://resources/fonction/soldat-de-protection-d-infrastructure.tres"),
	preload("res://resources/fonction/soldat-de-protection-d-ouvrage.tres"),
	preload("res://resources/fonction/soldat-de-ravitaillement.tres"),
	preload("res://resources/fonction/soldat-de-renseignement-topographe.tres"),
	preload("res://resources/fonction/soldat-de-sauvetage.tres"),
	preload("res://resources/fonction/soldat-de-securite-d-infrastructure.tres"),
	preload("res://resources/fonction/soldat-de-sport.tres"),
	preload("res://resources/fonction/soldat-de-surete.tres"),
	preload("res://resources/fonction/soldat-de-surete-acfa.tres"),
	preload("res://resources/fonction/soldat-de-surete-d-ouvrage.tres"),
	preload("res://resources/fonction/soldat-de-transmission.tres"),
	preload("res://resources/fonction/soldat-du-train.tres"),
	preload("res://resources/fonction/soldat-forces-speciales.tres"),
	preload("res://resources/fonction/soldat-meteorologue.tres"),
	preload("res://resources/fonction/soldat-nbc.tres"),
	preload("res://resources/fonction/soldat-radar.tres"),
	preload("res://resources/fonction/soldat-sanitaire.tres"),
	preload("res://resources/fonction/soldat-specialise-en-technique-d-ouvrage.tres"),
	preload("res://resources/fonction/soldat-technique-d-infrastructure.tres"),
	preload("res://resources/fonction/soldat-veterinaire.tres"),
	preload("res://resources/fonction/specialiste-de-montagne.tres"),
	preload("res://resources/fonction/specialiste-du-service-psychologique-et-pedagogique-de-l-armee.tres"),
	preload("res://resources/fonction/surete-de-base-aerienne-et-de-transport-aerien.tres"),
	preload("res://resources/fonction/tambour.tres"),
	preload("res://resources/fonction/trompette.tres"),
]

var fonction_modal = preload("res://scenes/modals/fonctions/fonctions_modal.tscn")
var fonction_scene = preload("res://scenes/badges/fonctions/fonction.tscn")
var modal_opener_scene = preload("res://scenes/pages/modal_opener.tscn")

func _ready() -> void:
	for fonction in fonctions:
		var fonction_node: Badge = fonction_scene.instantiate()
		var modal_opener: Node = modal_opener_scene.instantiate()
		fonction_node.r = fonction
		fonction_node.tenue_type = tenue_type
		modal_opener.linked_modal = fonction_modal
		modal_opener.add_child(fonction_node)
		update_badges_type.connect(fonction_node.set_type)
		$VBoxContainer/FonctionsContainer.add_child(modal_opener)

#func update_badges() -> void:
	#for fonction_modal_opener: Control in $VBoxContainer/FonctionsContainer.get_children():
		#var fonction: Badge = fonction_modal_opener.get_child(0)
		#fonction.tenue_type = tenue_type
		#fonction.update()
