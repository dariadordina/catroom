extends CharacterBody3D
class_name PlayerBase

# Kamera-Elemente (werden im Child gesetzt)
var twist_pivot: Node3D
var pitch_pivot: Node3D
var camera_pivot: Camera3D

## Gemeinsame Basis-Klasse für CatPlayer und HumanPlayer

var speed := 4.5
var run_speed := 8.0
var jump_velocity := 6.0
var gravity := -20.0

var active := false

var twist := 0.0
var pitch := 0.0
var mouse_sensitivity := 0.002

# Zoom
var zoom_distance := 0.0
var min_zoom := -1.0
var max_zoom := 1.0
var current_zoom := 0.0

var base_camera_position := Vector3.ZERO

func wake_up():
	active = true

func sleep():
	active = false

func init_camera_pivots(twist: Node3D, pitch: Node3D, cam: Camera3D):
	twist_pivot = twist
	pitch_pivot = pitch
	camera_pivot = cam

	base_camera_position = camera_pivot.position

	# Nur twist & pitch als FLOATS setzen – nicht die Pivots!
	self.twist = twist_pivot.rotation.y
	self.pitch = pitch_pivot.rotation.x
	current_zoom = zoom_distance

func update_camera_controls(delta: float):
	if not twist_pivot or not pitch_pivot or not camera_pivot:
		return

	# Rotation anwenden
	twist_pivot.rotation.y = twist
	pitch_pivot.rotation.x = pitch

	# Zoom relativ zur Basisposition (entlang -Z)
	current_zoom = lerp(current_zoom, zoom_distance, 5.0 * delta)
	#current_zoom = zoom_distance
	camera_pivot.position = base_camera_position + Vector3(0, 0, -current_zoom)

func update_zoom(amount: float):
	zoom_distance = clamp(amount, min_zoom, max_zoom)

func update_rotation(new_twist: float, new_pitch: float):
	twist = new_twist
	pitch = new_pitch
