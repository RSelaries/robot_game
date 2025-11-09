@tool
extends InteractableArea3D


@onready var csg_box_3d: CSGBox3D = $CSGBox3D


func _gained_focus() -> void:
	var stdr_mat: StandardMaterial3D = csg_box_3d.material
	stdr_mat.albedo_color = Color(0.673, 0.23, 0.655, 1.0)


func _lost_focus() -> void:
	var stdr_mat: StandardMaterial3D = csg_box_3d.material
	stdr_mat.albedo_color = Color("c1285a")
