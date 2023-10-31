extends InteractableRigid
class_name Item

#Any rigid body that inherits this class is a pickupable item


func interact():
	freeze = true


func stop_interaction():
	freeze = false
	sleeping = false

func _on_body_entered(_body):
	stop_interaction()

func held(position : Vector3):
	move_and_collide(position - self.global_position)
