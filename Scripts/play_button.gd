extends Button

@onready var play_button: Button = $"."

func _on_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
