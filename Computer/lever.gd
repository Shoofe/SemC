extends Interactable
class_name Lever
signal state_changed(amount: int)

var focused = false
var weight = 0.01
@onready var lever = $Lever


func _ready():
	disable_mouse = true

func interact():
	focused = true

func stop_interaction():
	focused = false

func _input(event):
	if event is InputEventMouseMotion and focused:
		lever.rotation.x += event.relative.y * weight
		lever.rotation.x = clamp(lever.rotation.x, deg_to_rad(-70), deg_to_rad(70))
		_on_state_changed()

func _on_state_changed():
	var amount = int((rad_to_deg(lever.rotation.x) + 71) / 1.4) #Botch
	emit_signal("state_changed", amount)
