extends State
class_name EnemyFollow

signal deal_damage_to_player(amount)

@export var enemy: CharacterBody2D
@export var move_speed := 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var player: CharacterBody2D

# enemy attack timing variables
var attack_cooldown := 1.5 # keep in mind this is in seconds before changing
var attack_timer := 0.0
var is_attacking := false

func enter():
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		print("Error: Player not found!")
	else:
		var callable = Callable(player, "_on_enemy_deal_damage")
		if not is_connected("deal_damage_to_player" , callable):
			connect("deal_damage_to_player",callable)

	attack_timer = 0.0
	is_attacking = false

func physics_update(delta: float):
	if player == null or enemy.is_dead: 
		return
	
	var direction = player.global_position - enemy.global_position
		
	if direction.length() > 80:
		enemy.velocity = direction.normalized() * move_speed
		animated_sprite_2d.play("Run")
		is_attacking = false
	else:
		enemy.velocity = Vector2()
		
		attack_timer -= delta
		if attack_timer <= 0.0 and not is_attacking:
			if not is_attacking:
				animated_sprite_2d.play("Attack")
				is_attacking = true
				attack_timer = attack_cooldown
				
	if is_attacking and animated_sprite_2d.animation == "Attack" and animated_sprite_2d.frame == 4:
		emit_signal("deal_damage_to_player", 10)
		is_attacking = false
		
	if direction.x < 0: 
		animated_sprite_2d.flip_h = false  
	elif direction.x > 0: 
		animated_sprite_2d.flip_h = true   

	if direction.length() > 600:
		Transitioned.emit(self, "idle")
