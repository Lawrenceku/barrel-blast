extends Node2D

# Preloaded scenes
var player_scene = preload("res://SCENES/player/player.tscn")
var gem = preload("res://SCENES/gem/gem.tscn")
var pool = [
	preload("res://SCENES/presets/preset_1.tscn"),
	preload("res://SCENES/presets/preset_2.tscn"),
	preload("res://SCENES/presets/preset_3.tscn"),
	preload("res://SCENES/presets/preset_4.tscn"),
	preload("res://SCENES/presets/preset_5.tscn"),
	preload("res://SCENES/presets/preset_6.tscn")
]


# Game variables
var player
var cannon
var current_preset
var next_preset
var screen_height = 1280
var screen_width = 720
var current_top = 0
var next_top = -screen_height

# Stats tracking
var health = 0

# Boundaries
var left_bound = 0
var right_bound = 720

func _ready():
	randomize()  # Initialize random number generator
	start_game()

func start_game():
	Global.gems = 0
	Global.barrels = 0
	player = player_scene.instance()
	add_child(player)
	player.position = $Position2D.position
	spawn_next_preset()

func spawn_next_preset():
	var preset = pool[randi() % pool.size()].instance()
	add_child(preset)
	preset.position.y = next_top
	next_top -= screen_height
	
	if current_preset:
		next_preset = preset
	else:
		current_preset = preset
	
	# Spawn items
	spawn_items()

func spawn_items():
	# Spawn gems (0-5)
	var gem_count = randi() % 6
	for i in range(gem_count):
		spawn_item("gem")

func spawn_item(item_type):
	var item = gem.instance()
	add_child(item)
	
	# Set random position within the view bounds
	var x = randf() * screen_width
	var y = next_top + randf() * screen_height
	item.position = Vector2(x, y)

func _process(delta):
	if player:
		if player.position.y <= current_top - screen_height:
			move_to_next_preset()
		_check_player_bounds()

func move_to_next_preset():
	if current_preset:
		current_preset.queue_free()
	current_preset = next_preset
	current_top = next_top + screen_height
	spawn_next_preset()

func _check_player_bounds():
	if player.position.x < left_bound or player.position.x > right_bound:
		var camera = player.get_node("Camera2D")
		camera.highShaker()  
		game_over()

func collect_barrel():
	Global.barrels += 1
	$AnimationPlayer.play("barrel_collected")
	_update_stats()

func collect_gem():
	$sound/gem.playing = true
	Global.gems += 1
	$AnimationPlayer.play("gem_collected")
	_update_stats()

func _update_stats():
	$CanvasLayer/HUD/barrels/Label.text = str(Global.barrels)
	$CanvasLayer/HUD/life/Label.text = str(health)
	$CanvasLayer/HUD/gems/Label.text = str(Global.gems)

func game_over():
	Global._on_game_over(Global.barrels, Global.gems)
	var game_over_scene = preload("res://SCENES/menus/gameover/gameover.tscn").instance()
	add_child(game_over_scene)
	get_tree().paused = true

func _on_pause_pressed():
	var pause_menu = preload("res://SCENES/menus/pausemenu/PauseMenu.tscn").instance()
	add_child(pause_menu)
	get_tree().paused = true
