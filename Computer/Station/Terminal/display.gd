extends Control

signal execute_command(command: String)


var screen_space_v = 13
var screen_space_h = 50
var screen_text = []
var screen_command_caret = ">"
var terminal_caret = "_"

@onready var screen = $Screen
@onready var terminal = $Terminal

func _ready():
	for x in range(screen_space_v):
		screen_text.append("")
	terminal.add_text(terminal_caret)

#Commands will always be caps

#Screen stuff
func send(command: String):
	addLine(screen_command_caret + command)
	command = command.left(command.length()-1)
	execute(command)

func refresh():
	screen.clear()
	for x in range(screen_space_v):
		screen.add_text(screen_text[x] + "\n")

func addLine(text: String):
	text = text.left(text.length() - 1)
	for x in range(screen_space_v - 1):
		if screen_text[x] == "":
			screen_text[x] = text
			refresh()
			return
	for x in range(screen_space_v-1):
		screen_text[x] = screen_text[x + 1]
	screen_text[screen_space_v - 1] = text
	refresh()




#Terminal stuff
func terminalAddCharacter(ch: String):
	var s: String  = terminal.get_parsed_text()
	s = s.left(s.length() - 1)
	terminal.clear()
	terminal.add_text(s)
	terminal.add_text(ch)
	terminal.add_text(terminal_caret)

func terminalClear():
	terminal.clear()
	terminal.add_text(terminal_caret)

func terminalRemoveCharacter():
	var s: String  = terminal.get_parsed_text()
	s = s.left(s.length() - 2)
	terminal.clear()
	terminal.add_text(s)
	terminal.add_text(terminal_caret)

func execute(command: String):
	emit_signal("execute_command", command)
