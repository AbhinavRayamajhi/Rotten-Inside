extends State


func _enter() -> void:
	entity.velocity.y = entity.JUMP_VELOCITY
	entity.animation_player.play("jump")


func _physics_update(delta: float) -> void:
	entity.apply_gravity(delta, Enums.Gravity.REGULAR)
	entity.handle_horizontal_movement(delta)
	# Double Jump
	if Input.is_action_just_pressed("jump") and entity.is_double_jump_available:
		change_state.emit(&"double_jump")
		return
	# Dash
	if Input.is_action_just_pressed("dash") and entity.is_dash_available:
		change_state.emit(&"dash")
		return
	# Fall
	if not entity.is_on_floor() and entity.velocity.y >= 0:
		change_state.emit(&"fall")
	
	
