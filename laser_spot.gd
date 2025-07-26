extends Node3D

# Bereich, in dem sich der Laser bewegt
@onready var laser_area: Node3D = $"../laser_area" # oder Pfad anpassen

# Parameter für Verhalten
var min_speed := 2.0
var max_speed := 10.0
var move_speed := 5.0
var min_pause := 0.1
var max_pause := 0.4
var min_jump_distance := 1.0
var max_jump_distance := 4.0

# Lebensdauer des Lasers
var timer := 0.0
@export var lifetime := 60.0

# Bewegungssteuerung
var target_pos : Vector3
var paused := false
var pause_timer := 0.0

func _ready():
	randomize()
	_set_new_target()

func _process(delta):
	# Lebenszeit prüfen
	timer += delta
	if timer > lifetime:
		queue_free()
		return

	# Pausen-Logik
	if paused:
		pause_timer -= delta
		if pause_timer <= 0.0:
			paused = false
			_set_new_target()
		return

	# Richtung und Bewegung
	var dir = (target_pos - global_transform.origin)
	var distance = dir.length()

	if distance < 0.2:
		# Kleine Pause bevor neuer Sprung
		paused = true
		pause_timer = randf_range(min_pause, max_pause)
	else:
		dir = dir.normalized()
		global_translate(dir * move_speed * delta)

func _set_new_target():
	# zufällige Geschwindigkeit für diesen Sprung
	move_speed = randf_range(min_speed, max_speed)

	# zufälligen Punkt innerhalb des erlaubten Bereichs bestimmen
	var x = clamp(global_transform.origin.x + randf_range(-max_jump_distance, max_jump_distance),
		laser_area.position.x,
		laser_area.position.x + laser_area.size.x)
	var z = clamp(global_transform.origin.z + randf_range(-max_jump_distance, max_jump_distance),
		laser_area.position.z,
		laser_area.position.z + laser_area.size.z)

	target_pos = Vector3(x, 0, z)
