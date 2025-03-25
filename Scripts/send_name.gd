extends Control
@onready var control: Control = $"."
@onready var name_input: LineEdit = $Panel/nameInput
@onready var enter_button: Button = $Panel/enterButton
@onready var congratulations_label: Label = $Panel/congratulations_label

var score_node
var player_score
var is_name_entered = false

func _ready() -> void:
	control.hide()
	enter_button.pressed.connect(on_enter_pressed)

#call this function to show enter name window when player dies	
func show_enter_name():
	if is_name_entered:
		return
	player_score = Game_manager.global_score
	congratulations_label.text = "Your score is: %d" % player_score
	control.show()

	
func on_enter_pressed():
	var name = name_input.text
	#send to create and save record	
	Game_manager.create_record(name, player_score)
	is_name_entered = true 
	control.hide()
