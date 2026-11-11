extends State


func _enter() -> void:
	entity.is_double_jump_available = true


func _update() -> void:
	# Jump
	if Input.is_action_just_pressed("jump"):
		change_state.emit(&"jump")
		return
	# Dash
	if Input.is_action_just_pressed("dash") and entity.is_dash_available:
		change_state.emit(&"dash")
		return
	# Fall
	if entity.velocity.y > 0:
		change_state.emit(&"fall")
		return
	# Idle
	if entity.velocity.y == 0:
		change_state.emit(&"idle")


func _physics_update(delta: float) -> void:
	entity.apply_gravity(delta, Enums.Gravity.REGULAR)
	entity.handle_horizontal_movement(delta)
