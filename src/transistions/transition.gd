extends Area2D

@export var to_scene_path : String 
@export var to_scene_spawn : String



func _on_body_entered(body: Node2D) -> void:
	Events.scene_change_requested.emit(to_scene_path, to_scene_spawn)
