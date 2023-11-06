extends Node

#Global variables and gamestates

var frozen = false
var gravity = 9.8

func freeze_switch():
	frozen = !frozen
