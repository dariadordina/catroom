extends Window

signal start_laser_game

@onready var play_button = $ButtonPlay

func _ready():
	play_button.pressed.connect(_on_play_pressed)
	hide()

func _on_play_pressed():
	play_button.disabled = true   # Während Spiel deaktivieren
	emit_signal("start_laser_game")

func enable_button():
	play_button.disabled = false
