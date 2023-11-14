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

var recorded_values: Dictionary = {
	"position":[],
	"rotation":[],
	"velocity":[]
}

var max_array_size = Global.record_seconds * Engine.physics_ticks_per_second
var is_held = false
var flushed = false


func _ready():
	freeze_mode = RigidBody3D.FREEZE_MODE_KINEMATIC
	Global.setMaxArraySize(max_array_size)


func _physics_process(_delta):

	#HERE
	if flushed:
		if Global.state != Global.State.IDLE:
			Global.setState(Global.State.IDLE)
		flushed = false
		linear_velocity = Vector3(0.1,0.1,0.1)
	
	#Each frame we update the array size
	Global.setArraySize(recorded_values["position"].size())
	
	
	#Because of a race condition when having multiple objects we will flush and then do the rest at the start of the next frame just above GOTO: HERE
	if Global.state == Global.State.FLUSH:
		flush()
	
	if Global.recording:
		#If the recording is full, pop from the front
		if recorded_values["position"].size() == max_array_size:
			for key in recorded_values:
				recorded_values[key].pop_front()
		#We now are sure we have space in the array and we save the current state of the obj
		recorded_values["position"].append(global_position)
		recorded_values["rotation"].append(global_rotation)
		recorded_values["velocity"].append(linear_velocity)


	if Global.state == Global.State.PLAYING:
		#If we're playing we have two cases: (1)We have some states already recorded and we play back those states.
		#                                 or (2)We are recording new movement
		#This is descided by inspecting the offset. If it's zero, we have nothing to play and we're recording new movement, otherwise, we lower the offset by one
		#and bring the state closer to "now"
		if Global.frame_offset != 0:
			Global.offsetDecrement()
		#And if it is zero after this, and we're playing, we must start recording, as me moved into the other state (2)
		#And we must release the control over the object to the psysics
		else:
			Global.setState(Global.State.IDLE)
		
	
	if Global.state == Global.State.REWINDING:
		#If we're rewinding we must be carefull as not to exit the array bounds. This means we have to keep our frame_offset less than max_array_size,
		#As we expect for our array to always be "full" during this manipulation. Because of that once they're equal we must freeze as to disable further rewinding.
		#Once we reach the end of the recording in the past (the first states recorded) we will just freeze the object.
		if Global.frame_offset + 1 == max_array_size:
			Global.setState(Global.State.FROZEN)
		#The rewinding is just simply increasing the frame_offest as that gets our state that is one frame further in the past.
		else:
			Global.offsetIncrement()
		
	#Each frame we check if we filled the array up to max_array_size
	if Global.max_array_size == recorded_values["position"].size():
		Global.recorded_full = true
	else:
		Global.recorded_full = false
	
	
	
	if not Global.state == Global.State.IDLE and Global.recorded_full and Global.max_array_size >= Global.frame_offset:
		freeze = true
		global_position = recorded_values["position"][Global.max_array_size - Global.frame_offset - 1]
		global_rotation = recorded_values["rotation"][Global.max_array_size - Global.frame_offset - 1]
		linear_velocity = recorded_values["velocity"][Global.max_array_size - Global.frame_offset - 1]
	else:
		freeze = false
	if Global.state == Global.State.FROZEN:
		linear_velocity = Vector3.ZERO
	is_held = false

func held(hand_position : Vector3):
	freeze = true
	if not Global.state == Global.State.IDLE and flushed:
		Global.setState(Global.State.FLUSH)
	is_held = true
	move_and_collide(hand_position - self.global_position)

func flush():
	for key in recorded_values:
		recorded_values[key].clear()
	Global.frame_offset = 0
	flushed = true


func interact():
	_on_interacted()

func stop_interaction():
	_on_stop_interaction()

func _on_interacted():
	pass
	
func _on_stop_interaction():
	pass
