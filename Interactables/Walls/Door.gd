extends StaticBody3D

var opened = false
var state_closed = Vector3(0,0,0)
var state_opened = Vector3(0,2.25,0)


func _physics_process(delta):

	if opened:
		self.transform.origin = self.transform.origin.lerp(state_opened, 1 * delta)
	else:
		self.transform.origin = self.transform.origin.lerp(state_closed, 4 * delta)


func open(state: bool):
	opened = state

