extends StaticBody3D

@onready var screen = $Display/SubViewport/Screen
@onready var grid = $Display/SubViewport/Screen/Grid
func draw(text: String):
	#screen.clear()
	#screen.add_text(text)
	pass


func _on_terminal_screen_send_command(command):
	match command:
		"START":
			screen.setupArray(City.new(20, 20).getArray())
		"CHANGE COLOR":
			screen.grids[10][10].changeColor()

