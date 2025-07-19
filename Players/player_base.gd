extends CharacterBody3D
class_name PlayerBase

## Gemeinsame Basis-Klasse für CatPlayer und HumanPlayer

var speed := 5.0
var run_speed := 10.0
var jump_velocity := 8.0
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

func update_camera_controls(twist_pivot, pitch_pivot, camera_pivot, delta):
	twist_pivot.rotation.y = twist
	pitch_pivot.rotation.x = pitch
	current_zoom = lerp(current_zoom, zoom_distance, 5.0 * delta)
	camera_pivot.position = base_camera_position + Vector3(0, 0, -current_zoom)

func update_zoom(amount: float):
	zoom_distance += amount
	zoom_distance = clamp(zoom_distance, min_zoom, max_zoom)

func update_rotation(rel_x: float, rel_y: float):
	twist -= rel_x * mouse_sensitivity
	pitch -= rel_y * mouse_sensitivity
	pitch = clamp(pitch, deg_to_rad(-90), deg_to_rad(90))
