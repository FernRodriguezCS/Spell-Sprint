extends Node2D
@onready var enter_name: Control = $enter_name
@onready var darken: ColorRect = $darken
@onready var increase = 0.00
@onready var curtain = $curtain
@onready var curtain2 = $curtain2
@onready var player = $Player
@onready var spotlight = $light
@onready var lightdim = 0.00
@onready var toleader = $score
@onready var leave = $exit
@onready var health_bar: ProgressBar = $healthBar
@onready var score = $Score_label
@onready var click = $click_to_continue
@onready var deathS = $deathsound
@onready var mmmusic = $MainMenuMusic
var curt_move = 1

func _ready():
	#AudioServer.set_bus_mute(0, true)
	var mmmusic = AudioServer.get_bus_index("MainMenuMusic")
	AudioServer.set_bus_mute(mmmusic, true)
	toleader.hide()
	leave.hide()
	player.health_bar.hide()
	player.score.hide()
	player.animation_player.play("death")
	
	player.score.position.x = -100
	player.score.position.y = 30
	
	# this stops the player from moving
	player.set_process(false)
	player.set_physics_process(false)

func _process(_delta: float) -> void:
	darken.set_color(Color(0,0,0,increase))
	increase += 0.006
	if curt_move <= 151:
		curtain.position.x += -4
		curtain2.position.x += +4
		curt_move += 1
	if lightdim <= .15:
		spotlight.self_modulate.a = lightdim
		lightdim += .04
		lightdim -= .02
		lightdim += .05
		lightdim += .04

func _input(event):
	if event is InputEventMouseButton:
		click.hide()
		if not enter_name.is_name_entered: 
			enter_name.show_enter_name()
		toleader.show()
		leave.show()

func _on_score_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/leaderboard_scene.tscn")
	AudioServer.set_bus_mute(0, false)
	#AudioServer.set_bus_mute(mmmusic, false)

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
	AudioServer.set_bus_mute(0, false)
	#AudioServer.set_bus_mute(mmmusic, false)
