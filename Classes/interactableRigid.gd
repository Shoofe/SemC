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

var rewind_values: Dictionary = {
	"position":[],
	"rotation":[],
	"velocity":[]
}

#TODO: Implement freeze with rewind
func _physics_process(delta):
	if not Global.rewinding and not Global.frozen:
		if Global.rewind_seconds * Engine.physics_ticks_per_second == rewind_values["position"].size():
			for key in rewind_values.keys():
				rewind_values[key].pop_front()
		rewind_values["position"].append(global_position)
		rewind_values["rotation"].append(rotation)
		rewind_values["velocity"].append(linear_velocity)
	elif Global.rewinding:
		compute_rewind(delta)

func compute_rewind(tick: float):
	var pos = rewind_values["position"].pop_back()
	var rot = rewind_values["rotation"].pop_back()
	if rewind_values["position"].is_empty() or not Global.rewinding:
		global_position = pos
		global_rotation = rot
		linear_velocity = rewind_values["velocity"][0]
		Global.rewinding = false
		return
	global_position = pos
	global_rotation = rot
	

func interact():
	_on_interacted()

func stop_interaction():
	_on_stop_interaction()

func _on_interacted():
	pass
	
func _on_stop_interaction():
	pass
