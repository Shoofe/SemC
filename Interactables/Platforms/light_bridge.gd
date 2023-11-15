extends Node3D

var activated = false

@onready var bridge = $Bridge
@onready var collision = $Bridge/CollisionShape3D

#NOT WORKING LOL

func _ready():
	activate(false)

func activate(state):
	activated = state
	bridge.visible = activated
	collision.disabled = activated


func _on_pressure_plate_3__state_changed(state):
	activate(state)
