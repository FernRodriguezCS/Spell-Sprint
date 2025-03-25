extends Node

@onready var area_2d: Area2D = get_node("../Player/Area2D")
@onready var animation_player: AnimationPlayer = get_node("../Player/AnimationPlayer")
@onready var animated_sprite: AnimatedSprite2D:
	get:
		if target_enemy and target_enemy.has_node("AnimatedSprite2D"):
			return target_enemy.get_node("AnimatedSprite2D")
		return null
		
var target_enemy: CharacterBody2D = null  
var typed_text: String = ""  
var original_word: String = ""
var inputLock = false 
var score:int = 0
var enemyLocked = false
var nearby_enemies: Array = [] 

signal score_updated(new_score: int)

func _ready():
	area_2d.body_entered.connect(_on_body_entered)
	area_2d.body_exited.connect(_on_body_exited)
	
func set_target_enemy(enemy):
	if not enemyLocked and "word" in enemy and "word_label" in enemy:
		for e in nearby_enemies:
			if e != enemy and e.has_node("target_ruby"):
				e.get_node("target_ruby").visible = false
		target_enemy = enemy 
		typed_text = ""  
		original_word = target_enemy.word
		enemyLocked = true
		
		# debug
		#print("Current enemy set to: ", target_enemy.name, " with word: ", target_enemy.word)
		
		if enemy.has_node("target_ruby"):
			enemy.get_node("target_ruby").visible = true
		
func kill_enemy(enemy):
	if enemy == target_enemy:
		enemy.is_dead = true
		
		if animated_sprite:
			animated_sprite.play("die")
			
		await animation_player.animation_finished
		enemy.queue_free()
		if enemy in nearby_enemies:
			nearby_enemies.erase(enemy)
		clear_target_enemy()
		if nearby_enemies.size() > 0:
			set_target_enemy(nearby_enemies[0])
		
func clear_target_enemy():
	if target_enemy != null:
		# debug
		#print("Clearing enemy target: ", target_enemy.name)
		if target_enemy.has_node("target_ruby"):
			target_enemy.get_node("target_ruby").visible = false
		target_enemy = null
		typed_text = ""
		original_word = ""
		enemyLocked = false
		inputLock = false
		
func _input(event):
	var ignored_keys = ["up", "down", "left", "right", "enter", "shift", "ctrl", "alt"]
	
	if target_enemy and event is InputEventKey and event.is_pressed():
		var key = OS.get_keycode_string(event.keycode).to_lower()
		
		if inputLock == true and key != 'backspace':
			return
			
		if key.length() == 1 and not key in ignored_keys:
			typed_text += key
			update_word_label()
			# debug
			#print(typed_text)
		if key == "backspace":
			inputLock = false
			# removes last charcter 
			typed_text = typed_text.left(typed_text.length() -1)
			update_word_label()
			#debug
			#print("backsapce was pressed! current typed_text: ", typed_text)
			# resets position in code
			return
		if key == "enter":
			if typed_text == original_word:
				animation_player.play("attack")
				# debug
				#print("killing enemy")
				kill_enemy(target_enemy)
				# update score and emit signal to the label script
				score += 100
				Game_manager.global_score = score 
				#debug
				#print("your score is: " + str(score))
				emit_signal("score_updated" ,score)
			else:
				print("your word is not correct! TRY AGAIN")

func update_word_label():
	# if enemy has a label attached to it
	if target_enemy and "word_label" in target_enemy:
		# allows for label alteration (specifically colors)
		target_enemy.word_label.bbcode_enabled = true

		var correct_part = ""
		var incorrect_part = ""
		var remaining_part = ""

		for i in range(original_word.length()):
			# Player has typed this letter
			if i < typed_text.length():  
				if typed_text[i] == original_word[i]:
					correct_part += "[color=green]" + typed_text[i] + "[/color]"
					# if this code is called then the letter in incorrect
					# stop players ability to type 
				else:
					incorrect_part += "[color=red]" + original_word[i] + "[/color]"
					#print("You entered the wrong key. Locking your input")
					inputLock = true
			else:
				remaining_part += original_word[i]
		target_enemy.word_label.text = correct_part + incorrect_part + remaining_part

func _on_body_entered(body):
	if body is CharacterBody2D and body not in nearby_enemies and "word" in body:
		nearby_enemies.append(body)
		if target_enemy == null:
			set_target_enemy(body)
	
func _on_body_exited(body):
	if body in  nearby_enemies:
		nearby_enemies.erase(body)
	if body == target_enemy:
		#print("enemy has left area the target is being cleared!")
		clear_target_enemy()
		if nearby_enemies.size() > 0:
			set_target_enemy(nearby_enemies[0])
