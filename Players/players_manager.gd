extends Node3D
class_name PlayerManager

@onready var cat_player = $"/root/game/Players/cat_player"
@onready var human_player = $"/root/game/Players/human_player"
@onready var shader_rect := get_node("/root/game/view_shaders/human_shader")
@onready var cooldown_label = $"/root/game/UI/Window/CooldownLabel"
@onready var sleep_button = $"/root/game/UI/Window/SleepButton"

@onready var game_state := get_node("/root/game/Scripts/GameState")

func _ready():
	game_state.players = [cat_player, human_player]
	game_state.current_player = cat_player
	_activate_player(cat_player)

func _process(_delta):
	if game_state.time_left > 0.0:
		game_state.time_left -= _delta
		sleep_button.disabled = true
	else:
		cooldown_label.text = ""
		sleep_button.disabled = false

func _on_sleep_button_pressed():
	if game_state.time_left <= 0.0:
		switch_player()
		game_state.time_left = game_state.switch_cooldown

func switch_player():
	game_state.current_player.sleep()

	if game_state.current_player == cat_player:
		game_state.current_player = human_player
	else:
		game_state.current_player = cat_player

	_activate_player(game_state.current_player)
	game_state.time_left = game_state.switch_cooldown

func _activate_player(player):
	player.wake_up()

	for p in [cat_player, human_player]:
		p.set_process(false)
		p.set_physics_process(false)
		p.set_process_input(false)
		p.set_process_unhandled_input(false)

	player.set_process(true)
	player.set_physics_process(true)
	player.set_process_input(true)
	player.set_process_unhandled_input(true)

	for p in [cat_player, human_player]:
		var cam = _find_camera(p)
		if cam:
			cam.current = false

	var cam = _find_camera(player)
	if cam:
		cam.current = true

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
