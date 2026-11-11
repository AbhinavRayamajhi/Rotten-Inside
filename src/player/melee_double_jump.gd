extends State


func _enter() -> void:
	entity.is_double_jump_available = false
	entity.velocity.y = entity.JUMP_VELOCITY


func _update() -> void:
	# Dash
	if Input.is_action_just_pressed("dash") and entity.is_dash_available:
		change_state.emit(&"dash")
		return
	# Fall
	if entity.velocity.y > 0:
		change_state.emit(&"fall")


func _physics_update(delta: float) -> void:
	entity.apply_gravity(delta, Enums.Gravity.REGULAR)
	entity.handle_horizontal_movement(delta)
