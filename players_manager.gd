extends Node3D

@onready var cat_player = $cat_player
@onready var human_player = $human_player
@onready var shader_rect := get_node("/root/game/view_shaders/human_shader")

var current_player : Node = null

func _ready():
	current_player = cat_player
	_activate_player(current_player)

func _process(_delta):
	if Input.is_action_just_pressed("switch_player"):
		switch_player()

func switch_player():
	current_player.sleep()

	if current_player == cat_player:
		current_player = human_player
	else:
		current_player = cat_player

	_activate_player(current_player)

func _activate_player(player):
	player.wake_up()

	# Kamera
	for p in [cat_player, human_player]:
		var cam = _find_camera(p)
		if cam:
			cam.current = false

	var cam = _find_camera(player)
	if cam:
		cam.current = true

	# Shader aktivieren, wenn wir im "Katzen-Traum" sind
	shader_rect.visible = (player == human_player)

func _find_camera(player: Node) -> Camera3D:
	if player.has_node("TwistPivot/PitchPivot/Camera3D"):
		return player.get_node("TwistPivot/PitchPivot/Camera3D")
	elif player.has_node("Camera3D"):
		return player.get_node("Camera3D")
	else:
		for node in player.get_children():
			if node is Camera3D:
				return node
	return null
