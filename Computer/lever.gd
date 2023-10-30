extends InteractableStatic
class_name Lever
signal state_changed(amount: int)

var focused = false
var weight = 0.01
var lever_target
@onready var lever = $Lever


func _ready():
	disable_mouse = true
	lever_target = lever.rotation.x

func interact():
	focused = true

func stop_interaction():
	focused = false

func _input(event):
	if event is InputEventMouseMotion and focused:
		lever_target += event.relative.y * weight
		lever_target = clamp(lever_target, deg_to_rad(-70), deg_to_rad(70))
		_on_state_changed()

func _physics_process(_delta):
	lever.rotation.x = lerp(lever.rotation.x, lever_target, 0.1)

func _on_state_changed():
	var amount = int((rad_to_deg(lever.rotation.x) + 71) / 1.4) #Botch
	emit_signal("state_changed", amount)
