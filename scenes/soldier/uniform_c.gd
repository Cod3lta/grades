extends Uniform3D


func get_spring_arm(pos: CameraPosition) -> SpringArm3D:
	match pos:
		CameraPosition.DEFAULT:
			return $Positions/Default
		CameraPosition.GRADE:
			return $Positions/Grades
		CameraPosition.ARME_ET_SERVICE:
			return $Positions/ArmesServices
		CameraPosition.FONCTION:
			return $Positions/Fonction
		CameraPosition.PARTICULIERS:
			return $Positions/Particuliers
	push_error("Unknown camera position asked")
	return $Positions/Default
