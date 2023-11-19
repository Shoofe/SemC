extends Area3D

@export var message_on_trigger: String
@export var one_time = true

@export var enable_on_trigger: Global.State
@export var enable: bool

@export var disable_on_trigger: Global.State
@export var disable: bool


var triggered = false
func _on_body_entered(body):
	if body.is_in_group("Player") and not triggered:
		body.show_message(message_on_trigger)
		if one_time:
			triggered = true
		
		if disable:
			Global.disableState(disable_on_trigger)
		
		if enable:
			Global.enableState(enable_on_trigger)

func _on_body_exited(_body):
	pass # Replace with function body.
