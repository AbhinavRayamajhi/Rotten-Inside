extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera

var current_room : Node2D
var current_camera_limits : Rect2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.scene_change_requested.connect(load_room)
	load_room("res://src/scenes/scene_1/scene_1.tscn", "new_game_spawn")
	
func load_room(path : String, spawn : String):
	# Change out the old room for the new room
	var new_room = load(path).instantiate()
	self.add_child(new_room)
	
	if current_room:
		current_room.queue_free()
	current_room = new_room
	
	var player_spawn = new_room.get_node("Spawns/" + spawn)
	player.global_position = player_spawn.global_position
	
	# Figure out the camera limits for the new room
	# For easy debugging
	if not current_room.has_node("CameraLimits"):
		push_error("Room: " + path + " is missing CameraLimits")
		
	var area = current_room.get_node("CameraLimits") as Area2D
	var collision_shape = area.get_node("CollisionShape2D")
	# Collision shape needs to be transformed from its local cordinates to the global cordinates
	# for proper camera limits
	current_camera_limits = collision_shape.global_transform * collision_shape.shape.get_rect()
	camera.set_target(player)
	camera.change(current_camera_limits)
	
