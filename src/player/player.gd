extends CharacterBody2D


const SPEED = 450.0
const JUMP_VELOCITY = -850.0
const DASH_SPEED = 1400.0

const GRAVITY_MULT = 2.5
const FALLING_GRAVITY_MULT = 3.2
const TERMINAL_VELOCITY = 1300

enum State { NORMAL, DASH, WALL_SLIDE }

var current_state : State = State.NORMAL

var facing_direction : float = 1.0
var is_dash_available : bool = true # To avoid dash spam

var is_double_jump_available : bool = true

@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown


func _physics_process(delta: float) -> void:
	match current_state:
		State.NORMAL:
			handle_normal_state(delta)
		State.DASH:
			handle_dash_state(delta)
		State.WALL_SLIDE:
			pass
	move_and_slide()


# State handles
func change_state(new_state : State) -> void:
	current_state = new_state
	match new_state:
		State.NORMAL:
			# Transition to normal speed
			velocity.x = clamp(velocity.x, -SPEED, SPEED)
		State.DASH:
			velocity.x = facing_direction * DASH_SPEED
			velocity.y = 0
			is_dash_available = false
			dash_timer.start() 

func handle_normal_state(delta: float) -> void:
	# Add the gravity.
	if velocity.y > 0:
		velocity.y += get_gravity().y * FALLING_GRAVITY_MULT * delta
	else:
		velocity.y += get_gravity().y * GRAVITY_MULT* delta
	velocity.y = min(velocity.y, TERMINAL_VELOCITY)
	
	# Reset double jump if on floor
	if is_on_floor():
		is_double_jump_available = true
		
	# Get the input direction and handle the movement/deceleration.
	var input_direction := Input.get_axis("left", "right")
	if input_direction:
		facing_direction = sign(input_direction)
		velocity.x = input_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	# Handle jump and double jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
		elif is_double_jump_available:
			velocity.y = JUMP_VELOCITY
			is_double_jump_available = false
	
	# Handle dash
	if Input.is_action_just_pressed("dash") and is_dash_available:
		change_state(State.DASH)

func handle_dash_state(delta: float) -> void:
	# Keep dash velocity throughout the dash and stop falling
	velocity.x = facing_direction * DASH_SPEED
	velocity.y = 0


# Timers
func _on_dash_timer_timeout() -> void:
	if current_state == State.DASH:
		change_state(State.NORMAL)
	dash_cooldown.start()

func _on_dash_cooldown_timeout() -> void:
	is_dash_available = true
