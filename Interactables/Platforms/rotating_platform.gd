extends Node3D

@export var start_rotation: float
@export var end_rotation: float
@export var rotation_speed: float = 3
@onready var platform = $Platform

var activated = false

func _physics_process(delta):
	if activated:
		platform.rotation.z = lerp_angle(platform.rotation.z, deg_to_rad(end_rotation), rotation_speed * delta)
	else:
		platform.rotation.z = lerp_angle(platform.rotation.z, deg_to_rad(start_rotation), rotation_speed * delta)


func activate(state):
	activated = state

func _on_pressure_plate__state_changed(state):
	activate(state)






func _on_pressure_plate_2__state_changed(state):
	activate(state)


func _on_pressure_plate_3__state_changed(state):
	activate(state)
