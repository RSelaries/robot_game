@tool
class_name SceneHandler
extends Control


@export_file_path("*.tscn") var initial_scene: String


@onready var scene_container: SceneContainer = %SceneContainer
@onready var pxl_subvprt_cont: SubViewportContainer = %PixelateSubvprtContainer


var inital_scene_instance: Node


func _ready() -> void:
	Settings.pixelisation_amount_changed.connect(_on_pxl_amnt_changed)
	
	var initial_scene_pcked: PackedScene = load(initial_scene)
	inital_scene_instance = initial_scene_pcked.instantiate()
	scene_container.change_child(inital_scene_instance)


func _on_pxl_amnt_changed(new_pxl_amount: int) -> void:
	pxl_subvprt_cont.stretch_shrink = new_pxl_amount
