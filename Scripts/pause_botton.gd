extends Button

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Ensure button still works when paused
	connect("pressed", _on_pause_button_pressed)
	update_button_text()

func _on_pause_button_pressed():
	get_tree().paused = not get_tree().paused  # Toggle pause state
	update_button_text()

func update_button_text():
	text = "Resume" if get_tree().paused else "Pause"
