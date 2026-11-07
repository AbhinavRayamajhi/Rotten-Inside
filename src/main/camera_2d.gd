extends Camera2D

var target : Node2D

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if target:
		global_position = target.global_position

func set_target(new_target : Node2D) -> void:
	target = new_target

func change(limits : Rect2) -> void:
	self.limit_left = int(limits.position.x)
	self.limit_right = int(limits.end.x)
	self.limit_top = int(limits.position.y)
	self.limit_bottom = int(limits.end.y)
