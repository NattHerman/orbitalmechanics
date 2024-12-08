extends Marker3D

var zoom_ratio = 0.1
var pan_multiplier = 0.002
var rotation_multiplier = 0.01

@onready var camera: Camera3D = $Camera3D
@onready var planet_label = $PlanetLabel
@onready var planet_picker_ray: RayCast3D = $Camera3D/PlanetPickerRay
@onready var world = get_parent()

signal cam_unlock_override


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		camera.size *= 1 - zoom_ratio
	elif event.is_action_pressed("zoom_out"):
		camera.size *= 1 + zoom_ratio
	
	if event is InputEventMouseMotion:
		var mouse_movement = event.relative
		
		if Input.is_action_pressed("cam_orbit"):
			var local_up = transform.basis.y.normalized()
			var local_right = transform.basis.x.normalized()
			rotate(local_up, -mouse_movement.x * rotation_multiplier)
			rotate(local_right, -mouse_movement.y * rotation_multiplier)
			#rotation.y -= mouse_movement.x * rotation_multiplier
			#rotation.x += mouse_movement.y * rotation_multiplier
			
		elif Input.is_action_pressed("cam_pan"):
			if world.camera_mode != world.CAMLOCK_UNLOCKED:
				cam_unlock_override.emit()
				
			var local_up = transform.basis.y
			var local_right = transform.basis.x
			position -= local_right * mouse_movement.x * pan_multiplier * camera.size
			position += local_up * mouse_movement.y * pan_multiplier * camera.size
	
	
func _process(delta: float) -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_pos = camera.project_position(mouse_pos, 0.0)
	var forward = -transform.basis.z
	planet_picker_ray.look_at_from_position(ray_pos, ray_pos + forward)
	var hit = planet_picker_ray.get_collider()
	print(hit)
