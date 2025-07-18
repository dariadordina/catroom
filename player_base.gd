extends CharacterBody3D
class_name PlayerBase

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

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_distance += 0.3
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_distance -= 0.3
		zoom_distance = clamp(zoom_distance, min_zoom, max_zoom)
	if event is InputEventMouseMotion:
		twist -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-40), deg_to_rad(40))

func _process(delta):
	if not active:
		return
		
func update_camera_controls(twist_pivot, pitch_pivot, camera_pivot, delta):
	twist_pivot.rotation.y = twist
	pitch_pivot.rotation.x = pitch
	current_zoom = lerp(current_zoom, zoom_distance, 5.0 * delta)
	camera_pivot.position = base_camera_position + Vector3(0, 0, -current_zoom)
