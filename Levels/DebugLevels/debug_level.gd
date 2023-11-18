extends Node3D



func _ready():
	$Player.global_position = Global.player_relative_postion
	$Player.global_rotation = Global.player_relative_rotation


