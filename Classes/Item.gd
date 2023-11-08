extends InteractableRigid
class_name Item

#Any rigid body that inherits this class is a pickupable item




func interact():
	freeze = true
	sleeping = true

func stop_interaction():
	linear_velocity = Vector3.ZERO
	sleeping = false
	freeze = false

func _on_body_entered(_body):
	stop_interaction()

func held(hand_position : Vector3):
	move_and_collide(hand_position - self.global_position)
