extends ProgressBar

#onready var first_level_label = $ColorRect/Label
#onready var second_level_label = $ColorRect2/Label
pass
#func _ready():
#	update_display()
#	Global.connect('update_display', self, "update_display")
#	pass
#
#func _process(delta):
#	value = Global.score
#	pass
#
#func update_display():
#	min_value = Global.score
#	max_value = Global.next_score
#	first_level_label.text = str(Global.level)
#	second_level_label.text = str(Global.next_level)
#	pass
