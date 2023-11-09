extends Node

#Global variables for rewind
var gravity = 9.8
var frozen = false
var rewinding = false
var playing = true
var exiting = false
var rewind_seconds = 5.0
var rewind_state = 0 # 0 - 1 where 1 is charged

func rewind():
	rewinding = true
	frozen = false
	playing = false
	print("Rewinding")

func freeze():
	frozen = true
	rewinding = false
	playing = false
	print("Frozen")


func play():
	playing = true
	frozen = false
	rewinding = false
	print("Playing")

func exit():
	exiting = true
