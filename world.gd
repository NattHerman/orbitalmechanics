extends Node3D

@onready var camera = $FreeCam
@onready var camera_z = camera.position.z
@onready var orbital_system = $OrbitalSystem
@onready var label_time_mult = $CanvasLayer/TimeMultContainer/LabelTimeMult
@onready var body_select_label = $CanvasLayer/BodySelectContainer/BodySelectLabel
@onready var cam_lock_options: OptionButton = $"CanvasLayer/MarginContainer/CamLockOptions"

var lock_cam_to_center_of_mass = false
var camera_mode
var selected_body
var selected_body_index = 0
enum {CAMLOCK_MASSCENTER, CAMLOCK_BODY, CAMLOCK_UNLOCKED}

var camera_offset: Vector3 = Vector3(0, 0, 0)


func _ready() -> void:
	camera_mode = CAMLOCK_MASSCENTER


func validate_body():
	if not selected_body:
		increment_body(0)


func increment_body(delta: int):
	var bodies = orbital_system.get_children()
	var bodies_count = orbital_system.get_child_count()
	selected_body_index = (selected_body_index + delta + bodies_count) % orbital_system.get_child_count()
	selected_body = bodies[selected_body_index]
	body_select_label.text = "Body: " + str(selected_body_index)


func _process(_delta: float) -> void:
	var center_of_mass = orbital_system.calculate_center_of_mass()
	match camera_mode:
		CAMLOCK_MASSCENTER:
			camera.position = center_of_mass
		CAMLOCK_BODY:
			validate_body()
			camera.position = selected_body.position
		CAMLOCK_UNLOCKED:
			pass # just do nothing, chill for once. Take a moment to relax.
	$Debug.position = center_of_mass
	label_time_mult.text = str(GlobalChanges.time_multiplier) + "x"


func _on_double_time_mult_pressed() -> void:
	GlobalChanges.time_multiplier *= 2.0


func _on_halve_time_mult_pressed() -> void:
	GlobalChanges.time_multiplier /= 2.0


func _on_option_button_item_selected(index: int) -> void:
	camera_mode = index
	match camera_mode:
		CAMLOCK_BODY:
			validate_body()


func _on_body_increment_pressed() -> void:
	increment_body(1)


func _on_body_decrement_pressed() -> void:
	increment_body(-1)


func _on_free_cam_cam_unlock_override() -> void:
	camera_mode = CAMLOCK_UNLOCKED
	cam_lock_options.selected = 2
