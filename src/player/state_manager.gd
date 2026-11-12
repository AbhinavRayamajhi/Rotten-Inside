extends Node2D


@export var entity : CharacterBody2D

var states : Dictionary = {}
var current_state : State

@onready var melee_idle: State = $MeleeIdle
@onready var melee_walk: State = $MeleeWalk
@onready var melee_jump: State = $MeleeJump
@onready var melee_double_jump: State = $MeleeDoubleJump
@onready var melee_fall: State = $MeleeFall
@onready var melee_dash: State = $MeleeDash

var counter = 0

func _ready() -> void:
	if entity.current_mode == Enums.Mode.MELEE:
		states[&"idle"] = melee_idle
		states[&"walk"] = melee_walk
		states[&"jump"] = melee_jump
		states[&"double_jump"] = melee_double_jump
		states[&"fall"] = melee_fall
		states[&"dash"] = melee_dash
		
		current_state = melee_idle
		
	for state in states:
		states[state].change_state.connect(on_state_change)


func _process(delta: float) -> void:
	current_state._update()
	counter = (counter + 1) % 100
	if counter == 1:
		print(current_state)


func _physics_process(delta: float) -> void:
	entity.check_dash_cooldown(delta)
	current_state._physics_update(delta)
	entity.move_and_slide()


func on_state_change(state : StringName) -> void:
	current_state._exit()
	current_state = states[state]
	current_state._enter()
