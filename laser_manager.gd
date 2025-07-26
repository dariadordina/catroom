extends Node3D

@onready var laser_area = get_node("/root/game/Interactions/Laser/laser_area")
@onready var laser_spot = get_node("/root/game/Interactions/Laser/Laserspot")
@onready var popup = get_node("/root/game/UI/Play/LaserPopup")

var game_timer := 0.0
var popup_shown := false

func _ready():
	# LaserSpot am Anfang deaktivieren
	laser_spot.visible = false
	laser_spot.set_process(false)

	# Popup-Signal verbinden
	if popup:
		popup.start_laser_game.connect(start_laser_game)

func _process(delta):
	# Popup erst nach 1 Minute zeigen
	if not popup_shown:
		game_timer += delta
		if game_timer >= 20.0:
			_show_popup()

func _show_popup():
	print("📢 Versuche, Popup zu zeigen:", popup)
	if popup and not popup.visible:
		print("found?")
		popup.show()
		popup_shown = true
	else:
		push_error("⚠️ Popup wurde nicht gefunden oder ist bereits sichtbar!")

func start_laser_game():
	print("🐾 Laser-Minispiel gestartet!")

	# Timer zurücksetzen
	game_timer = 0.0
	popup_shown = false

	# LaserSpot aktivieren
	laser_spot.visible = true
	laser_spot.set_process(true)
	laser_spot.start_laser(laser_area)

	# Nach Ablauf → deaktivieren + Button freigeben
	await get_tree().create_timer(laser_spot.lifetime).timeout
	laser_spot.visible = false
	laser_spot.set_process(false)
	if popup:
		popup.enable_button()
