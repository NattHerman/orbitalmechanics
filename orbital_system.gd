extends Node3D

@onready var body_scene = load("res://body.tscn")
var bodies
const gravitational_constant = 10 #6.674#e-11


func calculate_center_of_mass():
	if bodies.size() == 0:
		return Vector3.ZERO
	var mass_and_position_products_sum := Vector3.ZERO
	var total_mass: float = 0.0
	for body in bodies:
		mass_and_position_products_sum += body.mass * body.position
		total_mass += body.mass
	var center_of_mass = mass_and_position_products_sum / total_mass
	return center_of_mass


func all_combinations(elements: Array, callback: Callable):
	var elements_left: Array = elements.duplicate()
	while elements_left.size() > 0:
		var A = elements_left.pop_front()
		for B in elements_left:
			callback.call(A, B)


func calculate_gravity(A, B):
	var distance_squared = (B.position - A.position).length_squared()
	var gravity_force = gravitational_constant * A.mass * B.mass / distance_squared
	return gravity_force


func apply_gravity(A, B):
	var gravity_force = calculate_gravity(A, B)
	var AtoB = (B.position - A.position).normalized()
	var BtoA = AtoB * -1
	A.acceleration += (gravity_force / A.mass) * AtoB
	B.acceleration += (gravity_force / B.mass) * BtoA


func _physics_process(_delta: float) -> void:
	bodies = get_children()
	all_combinations(bodies, apply_gravity)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("spawn"):
		var body = body_scene.instantiate()
		var mouse_pos = get_viewport().get_mouse_position()
		var spawn_pos = $"../Camera3D".project_position(mouse_pos, $"../Camera3D".position.z)
		body.position = spawn_pos
		add_child(body)
