extends CharacterBody3D

#Movement vars
@export var SPEED = 3
@export var SPRINT_MUL = 1.5
@export var MOUSE_SENS_CONST = 100
@export var acceleration = 0.25
@export var jump_stregth = 4
#Helper movement vars
var sprint = 1

#Interactable vars
var moveable = true
var lock_mouse = false
var hold_item = false
var throw_strength = 8

@onready var hand = $Head/Hand
@onready var raycast = $Head/RayCast3D

var current_target = null
var item_far = -2.0
var item_near = -1.5
var item_increment = 0.1

#Mouse vars
var mouse_sensitivity = 0.2
var mouse_relative_x = 0
var mouse_relative_y = 0

#View vars
var camera_target
var default_fov = 80
var max_zoom_out = 100
var max_zoom_in = 50
var zoom_increment = 2
@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var default_camera_pos = $Head/DefaultCameraPosition



func _ready():
	camera_target = default_camera_pos
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	handle_movement(delta)
	handle_interactions()



func handle_movement(delta):
	#Keeps camera in position. Allows for camera movement.
	camera.global_position = lerp(camera.global_position, camera_target.global_position, 0.2)
	
	#Keeps the held item in hand.
	if current_target != null and hold_item:
		current_target.held(hand.global_position)
	
	#Jump and sprint.
	if Input.is_action_pressed("SPACE") and is_on_floor():
		velocity.y = jump_stregth
	if Input.is_action_pressed("SHIFT"):
		sprint = SPRINT_MUL
	else:
		sprint = 1
	
	#Apply gravity if not on floor
	if not is_on_floor():
		velocity.y -= Global.gravity * delta
	
	#WASD Movement
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
	#Time freeze logic.
	if Global.recorded_full:
		if Input.is_action_just_pressed("F"):
			Global.setState(Global.State.FROZEN)
			if current_target != null:
				stop_interaction()
		if Input.is_action_just_pressed("R"):
			Global.setState(Global.State.REWINDING)
			if current_target != null:
				stop_interaction()
		if Input.is_action_just_pressed("T"):
			Global.setState(Global.State.PLAYING)
			if current_target != null:
				stop_interaction()
		if Input.is_action_just_pressed("G"):
			Global.setState(Global.State.FLUSH)
			if current_target != null:
				stop_interaction()
	#Throw on MOUSE2.
	if Input.is_action_just_pressed("MOUSE2") and hold_item:
		current_target.stop_interaction()
		current_target.apply_impulse((hand.global_position - camera.global_position).normalized() * throw_strength)
		hold_item = false
		current_target = null
	
	#Move item closer or father.
	if Input.is_action_just_released("MS_WHEEL_UP"):
		hand.transform.origin.z -= item_increment
	if Input.is_action_just_released("MS_WHEEL_DOWN"):
		hand.transform.origin.z += item_increment
	hand.transform.origin.z = clamp(hand.transform.origin.z, item_far, item_near)
	
	#Camera rotation
	if event is InputEventMouseMotion and !lock_mouse:
		rotation.y -= event.relative.x * mouse_sensitivity / MOUSE_SENS_CONST
		head.rotation.x -= event.relative.y * mouse_sensitivity / MOUSE_SENS_CONST
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func handle_interactions():
	#Interaction starts with M1
	if Input.is_action_just_pressed("MOUSE1"):
		#Case if Interactable is StaticBody
		if raycast.get_collider() is InteractableStatic:
			current_target = raycast.get_collider()
			current_target.interact()
			moveable = !current_target.disable_movement
			lock_mouse = current_target.disable_mouse
			if current_target.focus_camera: camera_target = current_target.focus_camera_position
		#Case if Interactable is RigidBody
		if raycast.get_collider() is InteractableRigid:
			current_target = raycast.get_collider()
			current_target.interact()
			hold_item = true
	#Releasing held item or stopping interaction
	if current_target != null and ((Input.is_action_just_released("MOUSE1") and !current_target.stay_focused) or Input.is_action_just_released(current_target.unfocus_key)):
		stop_interaction()

func stop_interaction():
		current_target.stop_interaction()
		hold_item = false
		moveable = true
		lock_mouse = false
		camera_target = default_camera_pos
		current_target = null
