extends Interactable

signal send_command(command: String)

var focused = false
var curr_text = ""

@onready var display  = $Display/SubViewport/Display


func _ready():
	disable_movement = true
	focus_camera = true
	stay_focused = true
	focus_camera_position = $FocusCamPosition


func _on_interacted():
		focused = true
func _on_stop_interaction():
	focused = false

func _input(event):
	if focused and event is InputEventKey and event.is_pressed():
		processKeypress(event.as_text())

func processKeypress(kp: String):
	if kp.length() > 1:
		if kp == "Enter":
			display.send(display.terminal.get_parsed_text())
			display.terminalClear()
		if kp == "Space":
			display.terminalAddCharacter(" ")
		if kp == "Backspace":
			display.terminalRemoveCharacter()
	else:
		display.terminalAddCharacter(kp)


func _on_display_execute_command(command):
	emit_signal("send_command", command)

