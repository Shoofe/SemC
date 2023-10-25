extends CharacterBody3D

signal terminal_focus

const SPEED = 1.5
const SPRINT_MUL = 1.5
const MOUSE_SENS_CONST = 100
var sprint = 1
var acceleration = 0.25
var gravity = 15
var moveable = true

#Mouse vars
var mouse_sensitivity = 0.2
var mouse_relative_x = 0
var mouse_relative_y = 0


#View vars
var default_fov = 80
var max_zoom_out = 100
var max_zoom_in = 50
var zoom_increment = 2
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var default_camera_pos = $Head/DefaultCameraPosition
var camera_target
@onready var raycast = $Head/RayCast3D

func _ready():
	camera_target = default_camera_pos
	default_fov = camera.fov
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

var current_target : Interactable = null

func _physics_process(delta):
	handle_movement(delta)
	handle_interactions()


func handle_movement(delta):
	camera.global_position = lerp(camera.global_position, camera_target.global_position, 0.2)
		
	if Input.is_action_pressed("SHIFT"):
		sprint = SPRINT_MUL
	else:
		sprint = 1
		
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var input_dir = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and moveable:
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

func handle_interactions():
	if Input.is_action_just_pressed("MOUSE1"):
		if raycast.get_collider() is Interactable:
			current_target = raycast.get_collider()
			current_target.interact()
			
			if current_target.disable_movement: moveable = false
			if current_target.focus_camera:
				camera_target = current_target.focus_camera_position
	
	if current_target != null and ((Input.is_action_just_released("MOUSE1") and 
	!current_target.stay_focused) or Input.is_action_just_released(current_target.unfocus_key)):
		moveable = true
		camera_target = default_camera_pos
		current_target.stop_interaction()
		current_target = null
