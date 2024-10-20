extends Camera3D

var zoom_ratio = 0.1
var movement_ratio = 0.002


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		size *= 1 - zoom_ratio
	elif event.is_action_pressed("zoom_out"):
		size *= 1 + zoom_ratio
	if event is InputEventMouseMotion and Input.is_action_pressed("pan"):
		var mouse_movement = event.relative
		position.x -= mouse_movement.x * movement_ratio * size
		position.y += mouse_movement.y * movement_ratio * size
