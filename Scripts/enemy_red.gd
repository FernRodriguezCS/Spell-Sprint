extends CharacterBody2D
 
@onready var word_label: RichTextLabel = $WordLabel 

var word : String 
var is_dead = false

# This runs as soon as the program starts and everything is loaded
# 1. Calls generate_random_word(words range from 5 to 8 characters)
# 2. the @onready varable .text attribute is set to this word
#
func _ready():
	add_to_group("enemies")
	word = generate_random_word(2, 4) 
	word_label.text = word 

# This function generates and returns the random word that is called above
# 1. stores alphabet into a variable 'letters'
# 2. Creates and stores word length into var 'word_length' that has a 
#    range from min_length & max_length using randi_range (random int in range)
# 3. Initializes empty string to store our generated word
# 4. initialize i and loop it through the now set word_length
#    append characters from alphabet into 'random_word' variable
# 5. Return the word that gets generated 
#
func generate_random_word(min_length: int, max_length: int) -> String:
	var new_word = Game_manager.get_word()
	return new_word 
	
func _physics_process(_delta):
	if is_dead:
		return
	move_and_slide() 
