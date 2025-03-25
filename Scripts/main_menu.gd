extends Control
@onready var high_score: Control = $leaderboard
@onready var v_box_container: VBoxContainer = $VBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	high_score.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _on_leaderboard_button_pressed() -> void:
	high_score.show()
	
