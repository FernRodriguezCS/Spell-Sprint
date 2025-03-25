extends Node

@export var initial_state : State
@onready var enemy: CharacterBody2D = $Enemy_RED
@onready var typing_manager: Node = get_node("/root/Main/TypingManager")

var current_state : State
var states: Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transition)
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)
		
func _physics_process(_delta):
	if current_state:
		current_state.physics_update(_delta)

func on_child_transition(state, new_state_name):
	#debug
	#print("Transition signal received from ", state, "to ", new_state_name)
	
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	new_state.enter()
	
	current_state = new_state

func _on_body_entered(body):
	if body.is_in_group("enemies"): 
		#debug 
		#print("Enemy detected:", body.name) 
		typing_manager.set_target_enemy(body)
