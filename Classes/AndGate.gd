extends Node3D

var state1 = false
var state2 = false

signal output(state)

func _on_pressure_plate__state_changed(state):
	state1 = state
	check_states()


func _on_pressure_plate_2__state_changed(state):
	state2 = state
	check_states()

func check_states():
	emit_signal("output", state1 and state2)
		
