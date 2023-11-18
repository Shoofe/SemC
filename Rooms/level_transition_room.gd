extends Node3D

@onready var enterance = $Gate
@onready var exit = $Gate2
@onready var timer = $Timer

@export var is_start_of_level = false ##If you're using this as the end of the level or the start. By default: false
@export var next_level: String = "" ##The level which will be loaded after this.

var player = null
func _ready():
	#Opens the door according to their purpose
	enterance.open_door(!is_start_of_level)
	exit.open_door(is_start_of_level)


func _on_level_load_trigger_body_entered(body):
	#If this is just the start of the level or the body that entered is not the player we do nothing.
	if is_start_of_level or not body.is_in_group("Player"): return
	
	#If not, we close both doors, save our player position relative to the scene, and then start the timer at the end of which the scene will change
	enterance.open_door(false)
	exit.open_door(false)
	player = body
	timer.start()


func _on_timer_timeout():
	Global.player_relative_postion = player.global_position - self.global_position
	Global.player_relative_rotation = player.global_rotation - self.global_rotation
	get_tree().change_scene_to_file(next_level)
