extends Control


var screen_space_v = 15
var screen_space_h = 50
var screen_text = [screen_space_v]
var caret_pos = 0

func _ready():
	for x in range(screen_space_h):
		screen_text[x] = ""





func addLine(text: String):
	for x in range(screen_space_h):
		if screen_text[x] == "":
			screen_text[x] = text
			return
	for x in range(screen_space_h-1):
		screen_text[x] = screen_text[x + 1]
	screen_text[screen_space_h] = text
