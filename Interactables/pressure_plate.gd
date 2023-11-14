extends StaticBody3D

signal _state_changed(state: bool)

var pressed_position = Vector3(0, 0, 0)
var idle_position = Vector3(0, 0.05, 0)
var coliders = 0
@onready var button = $ButtonMesh

func _on_area_3d_body_entered(_body):
	#print("Pressed")
	coliders += 1
	_on_state_changed()

func _on_area_3d_body_exited(_body):
	#print("Deressed")
	coliders -= 1
	_on_state_changed()

func _physics_process(delta):
	if coliders > 0:
		button.transform.origin = button.transform.origin.lerp(pressed_position, 4 * delta)
	else:
		button.transform.origin = button.transform.origin.lerp(idle_position, 4 * delta)

func _on_state_changed():
	emit_signal("_state_changed", coliders > 0)
	
