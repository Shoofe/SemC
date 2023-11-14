extends StaticBody3D

@export var door = false
@onready var Door = $Door
func _ready():
	if door:
		$DoorColider.queue_free()
		$CSGCombiner3D/DoorMesh.visible = true
	else:
		Door.queue_free()




func _on_switch_switched(state):
	if door:
		Door.open(state)


func _on_lever_state_changed(amount):
	if amount > 80: Door.open(true)
	elif amount < 20: Door.open(false)


func _on_switch_2_switched(state):
	if door:
		Door.open(state)


func _on_lever_2_state_changed(amount):
	if amount > 80: Door.open(true)
	elif amount < 20: Door.open(false)


func _on_pressure_plate__state_changed(state):
	if door:
		Door.open(state)
