extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false
	animation_player.play("RESET")

func resume():
	visible = false  
	get_tree().paused = false
	animation_player.play_backwards("blur")

func pause():
	visible = true  
	get_tree().paused = true
	animation_player.play("blur")

func testEsc():
	if Input.is_action_just_pressed("escape"):
		if not visible:
			pause()
		else:
			resume()

func _on_resume_button_pressed() -> void:
	resume()

func _on_restart_button_pressed() -> void:
	resume()
	get_tree().reload_current_scene()

func _on_back_to_menu_button_pressed() -> void:
	resume()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _process(delta: float):
	testEsc()
