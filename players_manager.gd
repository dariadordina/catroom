extends Node3D

var players := []
var current_player : Node = null

func _ready():
	# Hole alle direkten Children = deine Player
	players = get_children()
	# Mache den ersten aktiv:
	current_player = players[0]
	_activate_player(current_player)

func _process(delta):
	if Input.is_action_just_pressed("switch_player"):
		switch_player()

func switch_player():
	current_player.sleep() # alle Players haben sleep()

	# Nächsten Player holen (wrap-around)
	var idx = players.find(current_player)
	idx = (idx + 1) % players.size()
	current_player = players[idx]

	_activate_player(current_player)

func _activate_player(player):
	player.wake_up()
	var player_camera = player.get_node("TwistPivot/PitchPivot/Camera3D")
	for p in players:
		var cam = p.get_node("Camera3D")
		if cam:
			cam.current = false

	if player_camera:
		player_camera.current = true
