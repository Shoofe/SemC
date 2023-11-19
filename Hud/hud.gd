extends Control

#Icon setup
@export var iconPause: Texture = null
@export var iconPlaying: Texture = null
@export var iconRewind: Texture = null
@export var iconRecording: Texture = null

@onready var icon = $Hud/StateIcon/Icon
@onready var blink = $Hud/StateIcon/Blink
var blinking = false
var blinked = false

#Progress bar setup
@onready var progress_bar = $Hud/RecordedProgress
@onready var current_frame = $Hud/CurrentFrame

func _ready():
	progress_bar.max_value = Global.record_seconds * Engine.physics_ticks_per_second
	current_frame.max_value = Global.record_seconds * Engine.physics_ticks_per_second

func _physics_process(_delta):
	$Hud.visible = Global.hud_visible
	progress_bar.value = Global.array_size
	current_frame.value = current_frame.max_value - Global.frame_offset
	
	changeIcon(Global.state)
	if blinking:
		icon.visible = blinked
	else:
		icon.visible = true

func changeIcon(state: Global.State):
	blinking = false
	match state:
		Global.State.IDLE:
			icon.texture = iconRecording
			blinking = true
			blink.wait_time = 0.6
			icon.visible = true
		
		Global.State.PLAYING:
			icon.texture = iconPlaying
		
		Global.State.REWINDING:
			icon.texture = iconRewind
			blinking = true
			blink.wait_time = 0.3
			icon.visible = true
		
		Global.State.FROZEN:
			icon.texture = iconPause

func _on_blink_timeout():
	blinked = !blinked

@onready var label = $msg
@onready var timer = $"Show message"

func show_message(message: String):	
	label.text = message
	timer.start()


func _on_show_message_timeout():
	label.text = ""
