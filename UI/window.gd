extends Window
@onready var spinner_rect := $UI/WindowPanel/ShaderRect
#@onready var spinner_material := spinner_rect.material

#func _process(delta):
	#if time_left > 0.0:
		#spinner_rect.visible = true
		#spinner_material.set_shader_parameter("time", Time.get_ticks_msec() / 1000.0)
	#else:
		#spinner_rect.visible = false
