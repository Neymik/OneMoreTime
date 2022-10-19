extends VBoxContainer

func _ready():
	pass # Replace with function body.


func _on_StartB_pressed():
# warning-ignore:return_value_discarded
	get_tree ().change_scene("res://Levels/Level0.tscn")
	pass # Replace with function body.


func _on_QuitB_pressed():
	get_tree ().quit ()
	pass # Replace with function body.
