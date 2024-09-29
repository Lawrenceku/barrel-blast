extends Node2D

var barrels = 0
var gems = 0
var savegame = File.new() # File object for save operations
var save_path = "user://savegame.save" # Path to the save file
var save_data = {"highscore": 0, "total_gems": 0} # Data to store: high score and total gems collected

func _ready():
	# Check if the save file exists; if not, create a new save
	if not savegame.file_exists(save_path):
		create_save()
	else:
		read_savegame() # Load the saved data

func create_save():
	# Create a new save file with initial data
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func save(high_score, gems_collected):
	# Update high score if the new score is higher
	if high_score > save_data["highscore"]:
		save_data["highscore"] = high_score
	
	# Add the collected gems to the total gems count
	save_data["total_gems"] = save_data.get("total_gems", 0) + gems_collected

	# Save the updated data to the file
	savegame.open(save_path, File.WRITE)
	savegame.store_var(save_data)
	savegame.close()

func read_savegame():
	# Open the save file and read the saved data
	savegame.open(save_path, File.READ)
	save_data = savegame.get_var() # Get the saved values as a dictionary
	savegame.close()

	# Ensure that 'total_gems' key is present in the data
	if not save_data.has("total_gems"):
		save_data["total_gems"] = 0

func get_highscore() -> int:
	# Returns the saved high score
	return save_data.get("highscore", 0)

func get_total_gems() -> int:
	# Returns the total gems collected across all playthroughs
	return save_data.get("total_gems", 0)

# Call this function to save the game data when needed
func _on_game_over(current_score, gems_collected):
	# Pass the current high score and the number of gems collected in this session to the save function
	save(current_score, gems_collected)
