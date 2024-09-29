extends CanvasLayer



# Called when the node enters the scene tree for the first time.
func _ready():
	Global.barrels = 0
	Global.gems = 0
	$highscore/Label.text = 'Highscore: '+str(Global.get_highscore())
	$Control/gems.text = str(Global.get_total_gems())
	get_tree().paused = false
	pass # Replace with function body.

func play():
		get_tree().change_scene("res://SCENES/demolevel/demoLevel.tscn")

func _on_Play_pressed():
	$AnimationPlayer.play("play_anim")
	pass 


func _on_Settings_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()

func _on_Store_pressed():
	pass # Replace with function body.

func _on_Leaderboard_pressed():
	pass # Replace with function body.
