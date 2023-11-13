extends InteractableRigid
class_name Item

#Any rigid body that inherits this class is a pickupable item




func interact():
	freeze = true


func stop_interaction():
	freeze = false
	linear_velocity = Vector3.ZERO


func _on_body_entered(_body):
	stop_interaction()

