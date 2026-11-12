extends State


func _enter() -> void:
	entity.is_double_jump_available = true
	entity.velocity.x = 0


func _physics_update(delta: float) -> void:
	entity.apply_gravity(delta, Enums.Gravity.REGULAR)
	# Jump
	if Input.is_action_just_pressed("jump") and entity.is_on_floor():
		change_state.emit(&"jump")
		return
	# Dash
	if Input.is_action_just_pressed("dash") and entity.is_dash_available:
		change_state.emit(&"dash")
		return
	# Walk
	if Input.get_axis("left", "right"):
		change_state.emit(&"walk")
		return
	# Fall
	if not entity.is_on_floor():
		change_state.emit(&"fall")
