extends Node

#Global variables and gamestates
var gravity = 9.8
var frozen = false
var rewinding = false
var rewind_seconds = 5.0

func rewind():
	rewinding = true
	frozen = false
	print("Rewind: ", rewinding, "\nFrozen: ", frozen)

func freeze():
	frozen = true
	rewinding = false
	print("Rewind: ", rewinding, "\nFrozen: ", frozen)

