extends Node

#Global variables for rewind
var gravity = 9.8

var record_seconds = 5.0
var recorded_full = false

var frame_offset = 0
var array_size = 0
var offset_changed = false
var max_array_size: int = 0


var recording = true
var state = State.IDLE

enum State {
	FROZEN,
	PLAYING,
	REWINDING,
	IDLE,
	FLUSH
}

func setState(st: State):
	state = st
	print("New state:", st)
	if state == State.IDLE:
		recording = true
	else:
		recording = false

func _physics_process(delta):
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
	#print(sz)
	array_size = sz
