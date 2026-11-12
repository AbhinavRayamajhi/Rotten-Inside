extends State


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
	# Stop falling
	if entity.is_on_floor():
		# Walk
		if Input.get_axis("left", "right"):
			change_state.emit(&"walk")
		# Idle
		else:
			change_state.emit(&"idle")
