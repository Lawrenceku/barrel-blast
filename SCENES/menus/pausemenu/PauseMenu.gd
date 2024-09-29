extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = true
	$AnimationPlayer.play("pause")


func _on_play_pressed():
	get_tree().paused = false
	self.queue_free()


func _on_back_pressed():
	get_tree().change_scene("res://SCENES/menus/main/mainMenu.tscn")
