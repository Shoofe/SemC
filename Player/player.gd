extends CharacterBody3D

signal terminal_focus

const SPEED = 1.5
const SPRINT_MUL = 1.5
const MOUSE_SENS_CONST = 100
var move = true
var sprint = 1
var acceleration = 0.25
var gravity = 15

#Mouse vars
var mouse_sensitivity = 0.2
var mouse_relative_x = 0
var mouse_relative_y = 0


#View vars
var default_fov = 80
var max_zoom_in = 100
var max_zoom_out = 20
var zoom_increment = 3
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var raycast = $Head/RayCast3D

func _ready():
	default_fov = camera.fov
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta):
	
	#Click
	if Input.is_action_just_pressed("MOUSE1"):
		interact()
	
	if Input.is_action_just_pressed("ui_cancel"):
		enteract()
	
	
	if Input.is_action_pressed("SHIFT"):
		sprint = SPRINT_MUL
	else:
		sprint = 1
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and move:
		velocity.x = lerp(velocity.x, direction.x * SPEED * sprint, acceleration)
		velocity.z = lerp(velocity.z, direction.z * SPEED * sprint, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * sprint)
		velocity.z = move_toward(velocity.z, 0, SPEED * sprint)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * mouse_sensitivity / MOUSE_SENS_CONST
		head.rotation.x -= event.relative.y * mouse_sensitivity / MOUSE_SENS_CONST
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

var interacting_with = null
func interact():
	var target: Interactable = raycast.get_collider()
	print(target)
	
	if target != null and target.is_in_group("Interactable"):
		target.interact()
		interacting_with = target
		disable_movement(target.disable_movement_on_interact)
		transform.origin += target.camera_position_on_focus.origin/2 + transform.origin

func enteract():
	if !move:
		move = true
		interacting_with.interact()

func disable_movement(type: bool):
	move = !type
