extends Node3D

@onready var camera = $Camera3D
@onready var camera_z = camera.position.z
@onready var orbital_system = $OrbitalSystem
@onready var label_time_mult = $CanvasLayer/VBoxContainer/LabelTimeMult

@export var camera_offset: Vector3 = Vector3(0, 0, 20)


func _process(_delta: float) -> void:
	var center_of_mass = orbital_system.calculate_center_of_mass()
	#camera.position = camera_offset + center_of_mass
	#camera.position.z = camera_z
	$Debug.position = center_of_mass
	label_time_mult.text = str(GlobalChanges.time_multiplier) + "x"


func _on_double_time_mult_pressed() -> void:
	GlobalChanges.time_multiplier *= 2.0


func _on_halve_time_mult_pressed() -> void:
	GlobalChanges.time_multiplier /= 2.0
