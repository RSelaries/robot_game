class_name PropertyWatcher
extends VBoxContainer


var watched_properties: Array[WatchedProperty]


class WatchedProperty:
	var object: Object
	var watched_property: NodePath
	
	var prop_value_label: Label


func _physics_process(_delta: float) -> void:
	for prop in watched_properties:
		var prop_value = prop.object.get_indexed(prop.watched_property)
		var prop_text: String = " "
		
		if prop_value is float:
			prop_text += str(snapped(prop_value, 0.1))
		elif prop_value is Vector3:
			prop_text += "x: " + str(snapped(prop_value.x, 0.1))
			prop_text += " y: " + str(snapped(prop_value.y, 0.1))
			prop_text += " z: " + str(snapped(prop_value.z, 0.1))
		elif prop_value == null:
			prop_text += "null"
		else:
			prop_text += str(prop_value)
		
		prop.prop_value_label.text = prop_text


func watch_property(from: Object, property: NodePath) -> void:
	_create_watched_prop_control(from, property)


func _create_watched_prop_control(obj: Object, prop: NodePath) -> void:
	var prop_panel := PanelContainer.new()
	prop_panel.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	
	var hbox := HBoxContainer.new()
	hbox.add_theme_constant_override("separation", 0)
	prop_panel.add_child(hbox)
	
	var prop_name_label := Label.new()
	var prop_name := str(prop)
	prop_name_label.text = prop_name.replace("_", " ").capitalize() + ":"
	hbox.add_child(prop_name_label)
	
	var prop_value_label := Label.new()
	hbox.add_child(prop_value_label)
	
	var new_watched_object := WatchedProperty.new()
	new_watched_object.object = obj
	new_watched_object.watched_property = prop
	new_watched_object.prop_value_label = prop_value_label
	add_child(prop_panel)
	watched_properties.append(new_watched_object)
