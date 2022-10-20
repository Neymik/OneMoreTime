extends Node2D
export var player = "res://Scenes/Characters/Player.tscn"

func _ready():
	instantiate_player()

func instantiate_player():

	var spawn_point = $TileMap.get_node("SpawnPoint")
	var player_spawn = load(player).instance()
	$TileMap.add_child(player_spawn)
	player_spawn.position = spawn_point.position
