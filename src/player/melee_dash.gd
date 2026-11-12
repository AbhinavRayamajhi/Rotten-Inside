extends State


func _enter() -> void:
	entity.dash_timer = entity.DASH_DURATION
	entity.dash_cooldown_timer = entity.DASH_COOLDOWN
	entity.is_dash_available = false


func _physics_update(delta: float) -> void:
	# Keep dash the same velocity throughout the dash
	entity.velocity.x = entity.facing_direction * entity.DASH_SPEED
	entity.velocity.y = 0
	entity.dash_timer -= delta
	# Only change state when dash is over
	if entity.dash_timer <= 0:
		if not entity.is_on_floor():
			change_state.emit(&"fall")
		elif entity.velocity.x:
			change_state.emit(&"walk")
		else:
			change_state.emit(&"idle")
