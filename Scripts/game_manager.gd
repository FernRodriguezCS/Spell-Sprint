extends Node

var leaderboard = []
var enemy_words = []
var names_path = "user://savedNames.json"
var words_path = "res://Asetts/words.json"

var max_names = 5
var global_score: int = 0

func _ready():
	load_leaderboard()
	load_words()
	
func get_player_score() -> int:
	return global_score

#load savefile into game when game start
func load_leaderboard():
	if FileAccess.file_exists(names_path):
		var file = FileAccess.open(names_path, FileAccess.READ)
		var record = file.get_as_text()
		file.close()
		#parse json records and add to leaderboard array
		record = JSON.parse_string(record)
		leaderboard = record
		
func load_words():
	if FileAccess.file_exists(words_path):
		var file = FileAccess.open(words_path, FileAccess.READ)
		var words = file.get_as_text()
		file.close()
		words = JSON.parse_string(words)
		enemy_words = words
		
#return random word
func get_word():
	var difficulty = "easy"
	var word
	var players_score = Game_manager.get_player_score()
	#debug
	#print("globy is"+ str( Game_manager.get_player_score()))
	if(players_score > 2000):
		difficulty = "medium"
	elif(players_score > 4000):
		difficulty = "hard"

	if difficulty in enemy_words:
		word = enemy_words[difficulty].pick_random()
	return word
	
#open json file and write current leadeboard contents
func save_leaderboard():
	var file = FileAccess.open(names_path, FileAccess.WRITE)
	print("saved score")
	#store leaderboard as formatted json record
	file.store_string(JSON.stringify(leaderboard, "\t") )
	file.close()

func create_record(user: String, score: int):
	var new_user = true
	#updata users score if already in file
	for record in leaderboard:
		if record["user"] == user:
			record["score"] = score
			new_user = false
			break

	if new_user:
		if leaderboard.size() >= max_names:
			#get lowest entry & replace with new entry
			var lowest_record = leaderboard[-1]
			if score > lowest_record["score"]:
				leaderboard.pop_back()
				leaderboard.append({"user": user, "score": score})
			else:
				print("score too low")
		#if leaderboard is not full just add new record
		else:
			leaderboard.append({"user": user, "score": score})
	#sort records and save
	leaderboard.sort_custom(compare_scores)
	save_leaderboard()
	
#return sorted leaderboard records
func compare_scores(a,b):
	return a["score"] > b["score"];
	
