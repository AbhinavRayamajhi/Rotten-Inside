extends Node2D

@onready var player: CharacterBody2D = $Player

var current_room : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_room("res://src/scenes/scene_1/scene_1.tscn", "new_game_spawn")
	Events.scene_change_requested.connect(load_room)


func load_room(path : String, spawn : String):
	var new_room = load(path).instantiate()
	self.add_child(new_room)
	
	if current_room:
		current_room.queue_free()
	
	current_room = new_room
	
	var player_spawn = new_room.get_node("Spawns/" + spawn)
	player.global_position = player_spawn.global_position
