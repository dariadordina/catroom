extends Window

signal sleep_requested()  # Wird an PlayerManager gesendet

@onready var sleep_button := $SleepButton
@onready var load_icon := $Load_Icon

var show_delay := 20.0  # Zeit bis zum ersten Anzeigen
var cooldown_time := 30.0
var time_passed := 0.0
var cooldown := 0.0

func _ready():
	sleep_button.visible = false
	sleep_button.disabled = true
	load_icon.visible = false

	sleep_button.pressed.connect(_on_sleep_button_pressed)

func _process(delta):
	time_passed += delta

	# Nach show_delay Sekunden Sleep-Button anzeigen
	if time_passed >= show_delay and not sleep_button.visible:
		sleep_button.visible = true
		sleep_button.disabled = false

	# Cooldown aktiv?
	if cooldown > 0.0:
		cooldown -= delta
		sleep_button.disabled = true
		load_icon.visible = true

		if cooldown <= 0.0:
			sleep_button.disabled = false
			load_icon.visible = false

func _on_sleep_button_pressed():
	if cooldown <= 0.0:
		emit_signal("sleep_requested")
		cooldown = cooldown_time
