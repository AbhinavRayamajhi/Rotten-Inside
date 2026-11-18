extends Camera2D


var target : Node2D
var camera_speed : float = 5.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float) -> void:
	if not target:
		return
	
	smoothing(delta)


func set_target(new_target : Node2D) -> void:
	target = new_target
	teleport()


func set_limits(limits : Rect2) -> void:
	self.limit_left = int(limits.position.x)
	self.limit_right = int(limits.end.x)
	self.limit_top = int(limits.position.y)
	self.limit_bottom = int(limits.end.y)


func smoothing(delta : float) -> void:
	global_position = global_position.lerp(target.global_position, 1.0 - exp(-camera_speed * delta))


func teleport() -> void:
	if target:
		global_position = target.global_position
		reset_smoothing()
