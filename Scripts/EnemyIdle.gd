extends State
class_name EnemyIdle

@export var enemy: CharacterBody2D
@export var move_speed := 100.0
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var player: CharacterBody2D
var move_direction: Vector2
var wander_time: float

func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)

func enter():
	player = get_tree().get_first_node_in_group("player") as CharacterBody2D
	if player == null:
		print("Error: Player not found!")
	randomize_wander()

func update(delta: float):
	if enemy.is_dead:
		return
		
	if wander_time > 0:
		wander_time -= delta
		animated_sprite_2d.play("Run")
	else:
		randomize_wander()

func physics_update(_delta: float):
	if player == null or enemy.is_dead: 
		return  

	if enemy:
		enemy.velocity = move_direction * move_speed 
		
		if move_direction.x > 0: 
			animated_sprite_2d.flip_h = true
		elif move_direction.x < 0: 
			animated_sprite_2d.flip_h = false

	var direction = player.global_position - enemy.global_position

	if direction.length() < 500:
		Transitioned.emit(self, "follow")
		
