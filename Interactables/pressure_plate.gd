extends StaticBody3D

signal _state_changed(state: bool)

var pressed_position = Vector3(0, 0, 0)
var idle_position = Vector3(0, 0.05, 0)
var coliders = 0
var pressed = false
var pressed_last_frame = false
@onready var button = $ButtonMesh

func _on_area_3d_body_entered(body):
	if body is RigidBody3D or body is CharacterBody3D:
		coliders += 1
		_on_state_changed()

func _on_area_3d_body_exited(body):
	if body is RigidBody3D or body is CharacterBody3D:
		coliders -= 1
		_on_state_changed()

func _physics_process(delta):
	
	if pressed and not pressed_last_frame:
		$SoundPress.play()
	elif not pressed and pressed_last_frame:
		$SoundDepress.play()
	pressed_last_frame = pressed
	
	if coliders > 0:
		button.transform.origin = button.transform.origin.lerp(pressed_position, 4 * delta)
	else:
		button.transform.origin = button.transform.origin.lerp(idle_position, 4 * delta)

func _on_state_changed():
	pressed = coliders > 0
	if pressed != pressed_last_frame:
		emit_signal("_state_changed", coliders > 0)
	
