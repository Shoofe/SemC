extends Node

#Global variables for rewind
var gravity = 9.8
var frozen = false
var rewinding = false
var playing = true
var exiting = false
var rewind_seconds = 5.0
var rewind_state = false

func rewind():
	rewinding = true
	frozen = false
	playing = false
	exiting = false
	print("Rewinding")

func freeze():
	frozen = true
	rewinding = false
	playing = false
	exiting = false
	print("Frozen")


func play():
	playing = true
	frozen = false
	rewinding = false
	exiting = false
	print("Playing")

func exit():
	exiting = true
