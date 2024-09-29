extends Node2D



func _ready():
	pass

func _on_collectGem_area_entered(area):
	get_tree().get_nodes_in_group('main')[0].collect_gem()
	self.queue_free()
