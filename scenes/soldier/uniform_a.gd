extends Uniform3D


func get_spring_arm(pos: CameraPosition) -> SpringArm3D:
	match pos:
		CameraPosition.DEFAULT:
			return $Positions/Default
		CameraPosition.BERET:
			return $Positions/Berets
		CameraPosition.ARME_ET_SERVICE:
			return $Positions/ArmesServices
		CameraPosition.FONCTION:
			return $Positions/Fonction
		CameraPosition.DISTINCTION:
			return $Positions/Distinctions
		CameraPosition.EPAULETTE:
			return $Positions/Epaulettes
	push_error("Unknown camera position asked")
	return $Positions/Default
