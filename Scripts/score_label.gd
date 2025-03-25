extends RichTextLabel

@onready var score_label: RichTextLabel = $"."
@onready var typing_manager = get_node("../../TypingManager")

func _ready() -> void:
	if get_tree().current_scene.name == "death":
		pass
	else: 
		typing_manager.score_updated.connect(update_score)
	
func update_score(new_score: int):
	score_label.text = 'Score: ' + str(new_score)
