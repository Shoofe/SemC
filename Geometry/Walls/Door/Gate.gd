extends StaticBody3D

@export var has_door = false
@export var starts_open = false
@export var close_when_passed = false

var door: StaticBody3D


func _ready():
	if has_door:
		door = preload("res://Geometry/Walls/Door/door.tscn").instantiate()
		add_child(door)
		door.open(starts_open)



func open_door(state):
	if has_door:
		door.open(state)


func _on_area_3d_body_entered(body):
	if body.is_in_group("Player") and close_when_passed:
		open_door(false)





func _on_pressure_plate__state_changed(state):
	if not starts_open:
		open_door(state)
	else:
		open_door(!state)




func _on_and_gate_output(state):
	if not starts_open:
		open_door(state)
	else:
		open_door(!state)


func _on_pressure_plate_3__state_changed(state):
	if not starts_open:
		open_door(state)
	else:
		open_door(!state)


func _on_pressure_plate_4__state_changed(state):
	if not starts_open:
		open_door(state)
	else:
		open_door(!state)

