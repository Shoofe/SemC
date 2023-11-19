extends Node3D

@export var spawn_on_ready = false
var item = null
@onready var item_preload = preload("res://Interactables/item.tscn")

func _ready():
	if spawn_on_ready:
		spawn()


func spawn():
	if item != null: item.queue_free()
	item = item_preload.instantiate()
	add_child(item)


func _on_pressure_plate__state_changed(state):
	if state:
		spawn()



