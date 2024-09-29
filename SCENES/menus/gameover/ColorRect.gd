extends ColorRect

var shader_material: ShaderMaterial
var transition_time = 0.0

func _ready():
	shader_material = material as ShaderMaterial

func _process(delta):
	if transition_time < 0.5:
		transition_time += delta
		shader_material.set_shader_param("transition_time", transition_time)
