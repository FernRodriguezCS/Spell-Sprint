extends Button

# signal to when pressed quit the game
func _on_pressed() -> void:
	get_tree().quit()
