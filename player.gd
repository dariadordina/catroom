extends CharacterBody3D

#Movement
var speed := 5.0
var run_speed := 10.0
var jump_velocity := 8.0
var gravity := -20.0
var cat_velocity := Vector3.ZERO


#mouse
var mouse_sensitivity := 0.002 #:= static type declaration = dynamic type decl
var twist := 0.0
var pitch := 0.0
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Zoom-Parameter
var zoom_distance := 5.0
var min_zoom := 2.0
var max_zoom := 10.0
var current_zoom := 5.0

# CameraPivot-Referenz (passe den Pfad an!)
@onready var camera_pivot = $TwistPivot/PitchPivot/Camera3D

# Animation
@onready var anim_player = $Cat2/AnimationPlayer


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-30), deg_to_rad(30))
		
	#Zoom
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			#zoom_distance -= 0.1
		#elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			#zoom_distance += 0.1

		#zoom_distance = clamp(zoom_distance, min_zoom, max_zoom)

func _process(_delta: float) -> void:
	twist_pivot.rotation.y = twist
	pitch_pivot.rotation.x = pitch
	
	#Zoom
	#current_zoom = lerp(current_zoom, zoom_distance, _delta)
	#camera_pivot.position.z = current_zoom

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta: float) -> void:
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_axis("move_left", "move_right")
	input_dir.z = Input.get_axis("move_forward", "move_back")
	input_dir = input_dir.normalized()

	# Kamera-Basis holen
	var basis = twist_pivot.basis

	# Kamerabasis auf XZ-Ebene projizieren (kein Up/Down!)
	var cam_x = basis.x
	cam_x.y = 0
	cam_x = cam_x.normalized()

	var cam_z = basis.z
	cam_z.y = 0
	cam_z = cam_z.normalized()

	# Bewegung in Kamerarichtung umrechnen
	var direction = (cam_x * input_dir.x) + (cam_z * input_dir.z)
	direction = direction.normalized()
	
	var is_running = Input.is_action_pressed("move_run")
	var current_speed = run_speed if is_running else speed

	# Bewegung
	if direction.length() > 0.01:
		cat_velocity.x = direction.x * current_speed
		cat_velocity.z = direction.z * current_speed

		# Drehung nur um Y-Achse, stabilisiert mit lerp_angle
		var target_rotation = atan2(direction.x, direction.z)
		$Cat2.rotation.y = lerp_angle($Cat2.rotation.y, target_rotation + PI, 0.15)

		# Animation
		if is_on_floor():
			if is_running:
				_play_anim_if_not_playing("cat_library/run")
			else:
				_play_anim_if_not_playing("cat_library/walk")
	else:
		# Sanft abbremsen
		cat_velocity.x = move_toward(cat_velocity.x, 0, speed)
		cat_velocity.z = move_toward(cat_velocity.z, 0, speed)

		if is_on_floor():
			_play_anim_if_not_playing("cat_library/idle")

	# Gravitation
	if not is_on_floor():
		cat_velocity.y += gravity * delta
	else:
		cat_velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			cat_velocity.y = jump_velocity
			_play_anim_if_not_playing("cat_library/jump")

	# Bewegung ausführen
	self.velocity = cat_velocity
	move_and_slide()
	
func _play_anim_if_not_playing(anim_name: String) -> void:
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)
