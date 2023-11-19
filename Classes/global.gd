extends Node

#Global variables for rewind
var gravity = 9.8

var record_seconds = 5.0
var recorded_full = false

var frame_offset = 0
var array_size = 0
var offset_changed = false
var max_array_size = record_seconds * Engine.physics_ticks_per_second


var recording = true
var state = State.IDLE

#A variable that keeps player position relative to the level-transition room.
var player_relative_postion: Vector3 = Vector3.ZERO
var player_relative_rotation: Vector3 = Vector3.ZERO

var state_available = [false,true,false,true,false]
var hud_visible = false



enum State {
	FROZEN,
	PLAYING,
	REWINDING,
	IDLE,
	FLUSH
}

func setState(st: State):
	if not state_available[st]:
		print("State ", st, " not available")
		return
	state = st
	print("Current state: ", st)
	if state == State.IDLE:
		recording = true
	else:
		recording = false

func enableState(st: State):
	state_available[st] = true
	print("Enabled state: ", st)

func disableState(st: State):
	state_available[st] = false
	print("Disabled state: ", st)


func enableAll():
	#Enable all states (DEBUG)
	for x in range(State.size()):
		state_available[x] = true

func _physics_process(_delta):
	offset_changed = false

func offsetDecrement():
	if offset_changed: return 
	frame_offset -= 1
	offset_changed = true

func offsetIncrement():
	if offset_changed: return 
	frame_offset += 1
	offset_changed = true

func setMaxArraySize(sz: int):
	if max_array_size != 0: return
	max_array_size = sz

func setArraySize(sz: int):
	array_size = sz


