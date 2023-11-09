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

var max_array_size = Global.rewind_seconds * Engine.physics_ticks_per_second
var current_tick_offset = 0

var frozen_last_frame = false



#TODO: Implement freeze with rewind
@warning_ignore("unused_parameter")
func _physics_process(delta):
	Global.rewind_state = rewind_values["position"].size() == max_array_size
	print(Global.rewind_state)
	#Each tick record values of the object into an array untill max_array_size if
	#the games not in state Frozen or Rewind
	
	
	if Global.exiting:
		if not Global.rewind_state: return
		Global.play()
		linear_velocity = Vector3.ZERO
		freeze = false
		frozen_last_frame = false
		current_tick_offset = 0
		for key in rewind_values:
			rewind_values[key].clear()
		return
	
	if rewind_values["position"].size() == max_array_size and not Global.frozen and not Global.rewinding and current_tick_offset == 0:
		for key in rewind_values:
			rewind_values[key].pop_front()
	if not Global.frozen and not Global.rewinding and current_tick_offset == 0:
		rewind_values["position"].append(global_position)
		rewind_values["rotation"].append(global_rotation)
		rewind_values["velocity"].append(linear_velocity)
	
	#If we just froze, freeze the object. 
	if Global.frozen and not frozen_last_frame:
		freeze = true
		frozen_last_frame = true
	
	#If we just unfroze, unfreeze the object and apply the last recorded velocity at max_array_size
	if not Global.frozen and frozen_last_frame and current_tick_offset == 0 and not Global.playing:
		if not Global.rewind_state: return
		freeze = false
		frozen_last_frame = false
		linear_velocity = Vector3.ZERO
		apply_impulse(rewind_values["velocity"][max_array_size - current_tick_offset - 1])
	
	#If the current frame offset is > 0, then we have to replay the motion we rewound
	if not Global.rewinding and not Global.frozen and current_tick_offset != 0:
		replay()
	
	#if we're rewinding, we just have to play the recorded motions backwards.
	if Global.rewinding:
		rewind()




func rewind():
	#To rewind we just move the object to the recorded position from rewind_values, offset by the frame
	if not Global.rewind_state: return
	current_tick_offset += 1
	if current_tick_offset == max_array_size:
		#If we rewound to the beginning of the recording
		Global.freeze()
		frozen_last_frame = true
		return
	print(max_array_size, " ", rewind_values["position"].size())
	global_position = rewind_values["position"][max_array_size - current_tick_offset]
	global_rotation = rewind_values["rotation"][max_array_size - current_tick_offset]
	

func replay():
	if not Global.rewind_state: return
	current_tick_offset -= 1
	if current_tick_offset == 0:
		#If we rewound to the beginning of the recording
		Global.play()
		frozen_last_frame = false
		return
	global_position = rewind_values["position"][max_array_size - current_tick_offset - 1]
	global_rotation = rewind_values["rotation"][max_array_size - current_tick_offset - 1]

func interact():
	_on_interacted()

func stop_interaction():
	_on_stop_interaction()

func _on_interacted():
	pass
	
func _on_stop_interaction():
	pass
