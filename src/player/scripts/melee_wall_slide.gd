extends State

var wall_normal : Vector2 = Vector2.ZERO

func _enter() -> void:
	wall_normal = entity.get_wall_normal()
	entity.velocity.y /= 2.5


func _physics_update(delta: float) -> void:	
	entity.apply_gravity(delta, Enums.Gravity.ON_WALL)
	
	var input_dir : float = Input.get_axis("left", "right")
	# If input direction is away from wall detach player
	if input_dir and sign(input_dir) == sign(wall_normal.x):
		entity.velocity.x = input_dir * entity.SPEED * 0.5
		change_state.emit(&"fall")
		return
	# Otherwise we slightly stick the player to the wall
	else:
		entity.velocity.x = -wall_normal.x * 5.0
		
	# Drop
	if entity.is_on_floor():
		change_state.emit(&"idle")
		return
	
	# Wall jump
	if Input.is_action_just_pressed("jump"):
		entity.velocity.x = wall_normal.x * entity.WALL_KICK_SPEED
		change_state.emit(&"jump")
		return
	
	# Move away from wall
	if not entity.is_on_wall():
		change_state.emit(&"fall")
		return
