extends Node3D

@onready var cat_player = $cat_player
@onready var human_player = $human_player
@onready var shader_rect := get_node("/root/game/view_shaders/human_shader")

var switch_cooldown := 120.0 # Sekunden
var time_left := 0.0
@onready var cooldown_label = $"/root/game/UI/Window/CooldownLabel"
@onready var sleep_button = $"/root/game/UI/Window/SleepButton"

var current_player : Node = null

func _ready():
	current_player = cat_player
	_activate_player(current_player)

func _process(_delta):
	if Input.is_action_just_pressed("switch_player"):
		switch_player()
		
	if time_left > 0.0:
		time_left -= _delta
		cooldown_label.text = "Warten: " + str(ceil(time_left)) + "s"
		sleep_button.disabled = true
	else:
		cooldown_label.text = ""
		sleep_button.disabled = false

func _on_sleep_button_pressed():
	if time_left <= 0.0:
		switch_player()
		time_left = switch_cooldown

func switch_player():
	current_player.sleep()

	if current_player == cat_player:
		current_player = human_player
	else:
		current_player = cat_player

	_activate_player(current_player)

	time_left = switch_cooldown

func _activate_player(player):
	player.wake_up()

	# Nur dieser Player verarbeitet nun Physik und Input
	for p in [cat_player, human_player]:
		p.set_process(false)
		p.set_physics_process(false)
		p.set_process_input(false)
		p.set_process_unhandled_input(false)

	player.set_process(true)
	player.set_physics_process(true)
	player.set_process_input(true)
	player.set_process_unhandled_input(true)

	# Kamera wechseln
	for p in [cat_player, human_player]:
		@warning_ignore("confusable_local_declaration")
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
