extends RigidBody3D
class_name InteractableRigid

#Any StaticBody3D that extends this class has methods for interaction with the player
#Mostly only used with items

var disable_movement = false
#Disable movement during interaction
var focus_camera = false
#Move the player camera to a custom position during interaction
var stay_focused = false
#Will stay in interaction if mouse1 is released
var unfocus_key = "ESCAPE"
#Always quit interaction on escape
var disable_mouse = false
#Disables mouse movement during interaction

var focus_camera_position : Node3D = null
#The position where the camera is when focused

var force = Vector3.ZERO
var last_frame_freeze = false

func _process(delta):
	freeze = Global.freeze
	if freeze and !last_frame_freeze:
		force = linear_velocity
		last_frame_freeze = true
	if !freeze and last_frame_freeze:
		linear_velocity = force
		last_frame_freeze = false
		

func interact():
	if !Global.freeze:
		_on_interacted()

func stop_interaction():
	_on_stop_interaction()

func _on_interacted():
	pass
	
func _on_stop_interaction():
	pass
