extends Area2D

@export var to_scene_path : String 
@export var to_scene_spawn : String
@export var end_point : Vector2
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision_shape_2d.shape.b = end_point


func _on_body_entered(body: Node2D) -> void:
	Events.scene_change_requested.emit(to_scene_path, to_scene_spawn)
