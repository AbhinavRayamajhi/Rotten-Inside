extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


const SPEED : float = 450.0
const DECELERATION : float = 2000.0
const JUMP_VELOCITY : float = -850.0
const DASH_SPEED : float = 1400.0
const DASH_DURATION : float = 0.3
const DASH_COOLDOWN : float = 0.8
const GRAVITY_MULT : float = 2.5
const FALLING_GRAVITY_MULT : float = 3.2
const TERMINAL_VELOCITY : float = 1300


var current_mode : Enums.Mode = Enums.Mode.MELEE

var current_gravity_mult : float = 1.0
var facing_direction : float = 1.0
var is_dash_available : bool = true # To avoid dash spam
var is_double_jump_available : bool = true


var dash_timer: float = 0
var dash_cooldown_timer: float = 0


# Helpers
func check_dash_cooldown(delta : float) -> void:
	if not is_dash_available:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			is_dash_available = true


func apply_gravity(delta : float, is_regular : Enums.Gravity) -> void:
	# Increase gravity multiplier if player falling and less gravity if not regular(wall slide,etc)
	current_gravity_mult = FALLING_GRAVITY_MULT if velocity.y > 0 else GRAVITY_MULT
	if is_regular == Enums.Gravity.ON_WALL: 
		current_gravity_mult /= 2
	# Add the gravity and limit it to terminal velocity
	velocity.y += get_gravity().y * current_gravity_mult * delta
	velocity.y = min(velocity.y, TERMINAL_VELOCITY)


func handle_horizontal_movement(delta : float) -> void:
	var input_direction := Input.get_axis("left", "right")
	if input_direction:
		facing_direction = sign(input_direction)
		velocity.x = input_direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	if facing_direction < 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
