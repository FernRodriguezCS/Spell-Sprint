extends CharacterBody2D

@export var speed = 300
@export var health: int = 100

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player: Sprite2D = $Sprite2D
@onready var health_bar: ProgressBar = $healthBar
@onready var score = $Score_label
@onready var walkS = $walksound
@onready var deathS = $deathsound
@onready var attackS = $blastattack

var can_move = true
var death_set = 0

func _physics_process(_delta):
	if can_move == true:
		if animation_player.current_animation == "attack" and animation_player.is_playing():
			move_and_slide()  # still allow physics even if animation is locked
			return
		var direction = Vector2.ZERO  # No movement by default
	
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
			animation_player.play("run")
			player.flip_h = true
		if Input.is_action_pressed("ui_right"):
			direction.x += 1
			animation_player.play("run")
			player.flip_h = false
		if Input.is_action_pressed("ui_up"):
			animation_player.play("run")
			direction.y -= 1
		if Input.is_action_pressed("ui_down"):
			animation_player.play("run")
			direction.y += 1
	
	# normalize to maintain consistent diagonal speed
		direction = direction.normalized()
		velocity = direction * speed
		move_and_slide()
	
		if direction == Vector2.ZERO && get_tree().get_current_scene().get_name() == "Main":
			animation_player.play("idle")
		
		if health <= 0:
			can_move = false
	
	if can_move == false:
		if death_set == 0:
			get_tree().change_scene_to_file("res://Scenes/death.tscn")
			health_bar.hide()
			position.x = 0
			position.y = 0
			death_set += 1

func _on_enemy_deal_damage(amount: int) -> void:
	health -= amount
	health_bar.value = health
	#debug
	#sprint("Player took", amount, "damage! Health is now:", health)

func _on_animation_player_animation_started(anim_name: StringName) -> void:
	if anim_name == "run":
		walkS.play()
	if anim_name == "death":
		deathS.play()
	if anim_name == "attack":
		attackS.play()
