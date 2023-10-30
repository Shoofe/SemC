extends InteractableRigid
class_name Item

func interact():
	freeze = true


func stop_interaction():
	freeze = false
	sleeping = false





func _on_body_entered(_body):
	stop_interaction()
