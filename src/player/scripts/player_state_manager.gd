extends StateManager


@onready var melee_idle: State = $MeleeIdle
@onready var melee_walk: State = $MeleeWalk
@onready var melee_jump: State = $MeleeJump
@onready var melee_double_jump: State = $MeleeDoubleJump
@onready var melee_fall: State = $MeleeFall
@onready var melee_dash: State = $MeleeDash


func _ready() -> void:
	# Add children to the dictionary
	if entity.current_mode == Enums.Mode.MELEE:
		states[&"idle"] = melee_idle
		states[&"walk"] = melee_walk
		states[&"jump"] = melee_jump
		states[&"double_jump"] = melee_double_jump
		states[&"fall"] = melee_fall
		states[&"dash"] = melee_dash
	# Connect their state change signals
	for state in states:
		states[state].change_state.connect(on_state_change)
	super._ready()


func _physics_process(delta: float) -> void:
	entity.check_dash_cooldown(delta)
	super._physics_process(delta)
