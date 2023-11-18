extends Node3D
@export var move_speed = 1
@export var move_destination_relative: Vector3
var move_start_destination = Vector3.ZERO

@onready var platform = $Platform
var activated = false


func _physics_process(delta):
	if activated:
		platform.translate((move_destination_relative - platform.transform.origin) * move_speed * delta)
	else:
		platform.translate((move_start_destination - platform.transform.origin) * move_speed * delta)

func activate(state: bool):
	activated = state

func _on_pressure_plate_2__state_changed(state):
	activate(state)

