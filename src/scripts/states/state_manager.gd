extends Node2D

class_name StateManager

@export var entity : CharacterBody2D
@export var current_state : State

var states : Dictionary = {}


func _ready() -> void:	
	current_state._enter()


func _process(delta: float) -> void:
	current_state._update()


func _physics_process(delta: float) -> void:
	current_state._physics_update(delta)
	entity.move_and_slide()


func on_state_change(state : StringName) -> void:
	var new_state = states[state]
	if current_state != new_state:
		current_state._exit()
		new_state._enter()
		current_state = new_state
