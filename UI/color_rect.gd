extends ColorRect

func _process(_delta):
	material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
