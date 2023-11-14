extends InteractableRigid
class_name Item

#Any rigid body that inherits this class is a pickupable item




func interact():
	if Global.state != Global.State.IDLE:
		flush()
	freeze = true
	is_held = true


func stop_interaction():
	freeze = false
	is_held = false
	apply_impulse(Vector3(0.1,0.1,0.1))
	


func _on_body_entered(body):
	if body is StaticBody3D:
		return
	stop_interaction()

