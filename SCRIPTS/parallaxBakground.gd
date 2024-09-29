extends ParallaxBackground

export (float) var scrolling_speed = 100.0
onready var layer1 = $ParallaxLayer

func _ready():
#	init_parrallax()
	pass

func _process(delta):
	scroll_offset.y += scrolling_speed * delta
