extends State


func _enter() -> void:
	entity.is_double_jump_available = true


func _physics_update(delta: float) -> void:
	entity.apply_gravity(delta, Enums.Gravity.REGULAR)
	entity.handle_horizontal_movement(delta)
	# Jump
	if Input.is_action_just_pressed("jump"):
		change_state.emit(&"jump")
		return
	# Dash
	if Input.is_action_just_pressed("dash") and entity.is_dash_available:
		change_state.emit(&"dash")
		return
	# Fall
	if not entity.is_on_floor():
		change_state.emit(&"fall")
		return
	# Idle
	if entity.velocity.x == 0:
		change_state.emit(&"idle")
