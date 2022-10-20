extends Node2D

# get tileMap
onready var worldTileMap = get_parent()

func _ready():
	pass # Replace with function body.

func do_what_this_object_does():
	print(name, " is an AbstractObject that can do something.")

func spawn_condition():
	return true
