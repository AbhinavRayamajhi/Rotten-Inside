extends CharacterBody2D


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


enum State { 
	IDLE,
	WALK, 
	JUMP,
	DOUBLE_JUMP,
	FALL,
	DASH, 
	WALL_SLIDE 
}

enum Gravity {
	REGULAR,
	ON_WALL
}


const SPEED : float = 450.0
const DECELERATION : float = 2000.0
const JUMP_VELOCITY : float = -850.0
const DASH_SPEED : float = 1400.0
const DASH_DURATION : float = 0.3
const DASH_COOLDOWN : float = 0.5
const GRAVITY_MULT : float = 2.5
const FALLING_GRAVITY_MULT : float = 3.2
const TERMINAL_VELOCITY : float = 1300


var current_gravity_mult : float = 1.0
var current_state : State = State.IDLE
var facing_direction : float = 1.0
var is_dash_available : bool = true # To avoid dash spam
var is_double_jump_available : bool = true


var dash_timer: float = 0
var dash_cooldown_timer: float = 0


func _physics_process(delta : float) -> void:
	check_dash_cooldown(delta)
	
	match current_state:
		State.IDLE:
			idle_state(delta)
		State.WALK:
			walk_state(delta)
		State.JUMP:
			jump_state(delta)
		State.DOUBLE_JUMP:
			double_jump_state(delta)
		State.FALL:
			fall_state(delta)
		State.DASH:
			dash_state(delta)
		State.WALL_SLIDE:
			pass
			
	move_and_slide()


# Helpers
func check_dash_cooldown(delta : float) -> void:
	if not is_dash_available:
		dash_cooldown_timer -= delta
		if dash_cooldown_timer <= 0:
			is_dash_available = true


func apply_gravity(delta : float, is_regular : Gravity) -> void:
	# Increase gravity multiplier if player falling and less gravity if not regular(wall slide,etc)
	current_gravity_mult = FALLING_GRAVITY_MULT if velocity.y > 0 else GRAVITY_MULT
	if is_regular == Gravity.ON_WALL: 
		current_gravity_mult /= 2
	# Add the gravity and limit it to terminal velocity
	velocity.y += get_gravity().y * current_gravity_mult * delta
	velocity.y = min(velocity.y, TERMINAL_VELOCITY)


func handle_movement_inputs() -> void:
	var input_direction := Input.get_axis("left", "right")
	# Handle jump and double jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			change_state(State.JUMP)
		elif is_double_jump_available:
			is_double_jump_available = false;
			change_state(State.DOUBLE_JUMP)	
	# Handle dash
	elif Input.is_action_just_pressed("dash") and is_dash_available:
		change_state(State.DASH)
	# Handle walking
	elif is_on_floor() and input_direction:
		change_state(State.WALK)


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


# State handles
func change_state(new_state : State) -> void:
	if new_state == current_state:
		return
		
	match new_state:
		State.JUMP:
			velocity.y = JUMP_VELOCITY
		State.DOUBLE_JUMP:
			velocity.y = JUMP_VELOCITY
		State.DASH:
			dash_timer = DASH_DURATION
			
	current_state = new_state


func idle_state(delta : float) -> void:
	velocity.x = move_toward(velocity.x, 0, SPEED)
	handle_movement_inputs()
	# Gravity
	apply_gravity(delta, Gravity.REGULAR)
	animated_sprite_2d.play("idle")


func walk_state(delta : float) -> void:
	handle_movement_inputs()
	handle_horizontal_movement(delta)
	# Gravity
	apply_gravity(delta, Gravity.REGULAR)
	if not Input.get_axis("left", "right"):
		change_state(State.IDLE)


func jump_state(delta : float) -> void:
	handle_movement_inputs()
	handle_horizontal_movement(delta)
	apply_gravity(delta, Gravity.REGULAR)
	if velocity.y >= 0:
		change_state(State.FALL)


func double_jump_state(delta : float) -> void:
	handle_movement_inputs()
	handle_horizontal_movement(delta)
	apply_gravity(delta, Gravity.REGULAR)
	if velocity.y >= 0:
		change_state(State.FALL)


func fall_state(delta : float) -> void:
	handle_movement_inputs()
	handle_horizontal_movement(delta)
	apply_gravity(delta, Gravity.REGULAR)
	if is_on_floor():
		is_double_jump_available = true
		if Input.get_axis("left", "right"):
			change_state(State.WALK)
		else:
			change_state(State.IDLE)


func dash_state(delta : float) -> void:
	# Keep dash velocity throughout the dash and stop falling
	velocity.x = facing_direction * DASH_SPEED
	velocity.y = 0
	dash_timer -= delta
	
	if dash_timer <= 0:
		dash_cooldown_timer = DASH_COOLDOWN
		is_dash_available = false
		velocity.x = clamp(velocity.x, -SPEED, SPEED)
		if not is_on_floor():
			change_state(State.FALL)
		elif Input.get_axis("left", "right"):
			change_state(State.WALK)
		else:
			change_state(State.IDLE)
