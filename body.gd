extends Node3D


@export var density: float = 30
@export var radius: float = 6.371
@export var mass: float = 1.0
@export var initial_velocity: Vector3 = Vector3.ZERO

var acceleration: Vector3 = Vector3.ZERO
var velocity: Vector3 = Vector3.ZERO

@onready var immediate_mesh := ImmediateMesh.new()
@onready var path_mesh := MeshInstance3D.new()
var max_path_points: int = 1000
var path_mesh_points: Array
var material: ORMMaterial3D

var default_clock_time = 0.05
var clock_wait_time = default_clock_time
@onready var previous_path_timestamp = Time.get_ticks_msec()


func _ready() -> void:
	velocity = initial_velocity
	
	path_mesh.mesh = immediate_mesh
	path_mesh.top_level = true
	add_child(path_mesh)
	
	material = ORMMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	
	update_radius(calc_radius(mass, density))


func _physics_process(realdelta: float) -> void:
	#print(name, " ", acceleration)
	var delta = GlobalChanges.time_multiplier * realdelta
	velocity += acceleration * delta
	position += velocity * delta
	acceleration = Vector3.ZERO
	var current_time = Time.get_ticks_msec()
	if current_time - previous_path_timestamp >= clock_wait_time:
		update_path()
		previous_path_timestamp = Time.get_ticks_msec()


func update_path() -> void:
	immediate_mesh.clear_surfaces()
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	path_mesh_points.append(global_position)
	var prev_path_point = global_position
	if path_mesh_points.size() > 0:
		prev_path_point = path_mesh_points [0]
	if path_mesh_points.size() > max_path_points:
		path_mesh_points.pop_front()
	for point in path_mesh_points:
		immediate_mesh.surface_add_vertex(prev_path_point)
		immediate_mesh.surface_add_vertex(point)
		prev_path_point = point
	immediate_mesh.surface_end()


func calc_radius(mass: float, density: float):
	var volume = mass / density
	var new_radius = ((3*volume)/(4*PI))**1/3
	return new_radius


func update_radius(new_radius: float):
	radius = new_radius
	$MeshInstance3D.mesh.radius = radius
	$MeshInstance3D.mesh.height = radius*2
	$Area3D/CollisionShape3D.shape.radius = radius


func _on_time_multiplier_changed():
	clock_wait_time = default_clock_time / GlobalChanges.time_multiplier


func _on_area_3d_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
