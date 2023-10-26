extends Interactable
class_name Switch

signal switched(state: bool)

var state = false
@onready var lever = $Lever/MeshInstance3D




func _on_change_state():
	emit_signal("switched", state) #Sends a bool to an object depending on the state of the switch

func switch():
	state = !state
	lever.transform.origin.x *= -1
	_on_change_state()

func interact():
	switch()
