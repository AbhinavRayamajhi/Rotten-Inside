extends CharacterBody2D


@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


const SPEED : float = 450.0
const ACCELERATION : float = 3000.0
const DECELERATION : float = 3000.0

const JUMP_VELOCITY : float = -800.0

const DASH_SPEED : float = 1300.0
const DASH_DURATION : float = 0.2
const DASH_COOLDOWN : float = 0.8


const WALL_KICK_SPEED : float = 450.0

const BODY_OFFSET_X : float = 70.0


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


func apply_gravity(delta : float, gravity_type : Enums.Gravity) -> void:
	# Increase gravity multiplier if player falling and less gravity if not regular(wall slide,etc)
	current_gravity_mult = Constants.FALLING_GRAVITY_MULT if velocity.y > 0 else Constants.RISING_GRAVITY_MULT
	if gravity_type  == Enums.Gravity.ON_WALL: 
		current_gravity_mult /= 2.5
	# Add the gravity and limit it to terminal velocity
	velocity.y += get_gravity().y * current_gravity_mult * delta
	velocity.y = min(velocity.y, Constants.TERMINAL_VELOCITY)


func handle_horizontal_movement(delta : float) -> void:
	var input_direction := Input.get_axis("left", "right")
	if input_direction:
		facing_direction = sign(input_direction)
		if is_on_floor():
			velocity.x = input_direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, input_direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	if facing_direction < 0:
		sprite_2d.flip_h = true
		sprite_2d.offset.x = -BODY_OFFSET_X # Sprite has a gap on the right so needs fixed
	else:
		sprite_2d.flip_h = false
		sprite_2d.offset.x = 0.0
