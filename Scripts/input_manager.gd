extends Node
class_name InputManager

signal zoom_changed(new_zoom : float)
signal camera_rotated(twist : float, pitch : float)
signal escape_pressed()

# Eingabeparameter
var zoom_distance := 0.0
var min_zoom := -0.6
var max_zoom := 0.6

var twist := 0.0
var pitch := 0.0
var mouse_sensitivity := 0.002
var input_unlocked := false

func _ready():
	set_process_unhandled_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _input(event: InputEvent):
	if not input_unlocked:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			zoom_distance += 0.3
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			zoom_distance -= 0.3
		zoom_distance = clamp(zoom_distance, min_zoom, max_zoom)
		if input_unlocked:
			emit_signal("zoom_changed", zoom_distance)

	elif event is InputEventMouseMotion:
		twist -= event.relative.x * mouse_sensitivity
		twist = clamp(twist, deg_to_rad(-30), deg_to_rad(30))
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-20), deg_to_rad(20))
		if input_unlocked:
			emit_signal("camera_rotated", twist, pitch)

func _process(_delta):
	if not input_unlocked and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		input_unlocked = true
		print("🟢 Input aktiviert")
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("ui_cancel"):
		input_unlocked = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		emit_signal("escape_pressed")
