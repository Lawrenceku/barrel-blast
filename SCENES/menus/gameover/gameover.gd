extends Control



func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("gameover")

func _on_replay_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://SCENES/demolevel/demoLevel.tscn")


func _on_back_pressed():
	get_tree().change_scene("res://SCENES/menus/main/mainMenu.tscn")
