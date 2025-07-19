extends PlayerBase

@onready var anim_player = $Cat2/AnimationPlayer
var cat_velocity := Vector3.ZERO

# Kamera
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot
@onready var camera_pivot := $TwistPivot/PitchPivot/Camera3D

func _ready():
	base_camera_position = camera_pivot.position

func _process(delta):
	if not active:
		return
	update_camera_controls(twist_pivot, pitch_pivot, camera_pivot, delta)

func _physics_process(delta):
	if not active:
		return

	# Bewegungseingabe
	var input_dir = Vector3(
		Input.get_axis("move_left", "move_right"),
		0,
		Input.get_axis("move_forward", "move_back")
	).normalized()

	# Kamerabasis für Bewegung berechnen
	var basis = twist_pivot.basis
	var cam_x = basis.x; cam_x.y = 0; cam_x = cam_x.normalized()
	var cam_z = basis.z; cam_z.y = 0; cam_z = cam_z.normalized()
	var direction = (cam_x * input_dir.x + cam_z * input_dir.z).normalized()

	var is_running = Input.is_action_pressed("move_run")
	var current_speed = run_speed if is_running else speed

	# Bewegung + Rotation
	if direction.length() > 0.01:
		cat_velocity.x = direction.x * current_speed
		cat_velocity.z = direction.z * current_speed

		# Drehung
		var target_rotation = atan2(direction.x, direction.z)
		$Cat2.rotation.y = lerp_angle($Cat2.rotation.y, target_rotation + PI, 0.15)

		if is_on_floor():
			_play_anim_if_not_playing("cat_library/run" if is_running else "cat_library/walk")
	else:
		cat_velocity.x = move_toward(cat_velocity.x, 0, speed)
		cat_velocity.z = move_toward(cat_velocity.z, 0, speed)
		if is_on_floor():
			_play_anim_if_not_playing("cat_library/idle")

	# Gravitation und Sprung
	if not is_on_floor():
		cat_velocity.y += gravity * delta
	else:
		cat_velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			cat_velocity.y = jump_velocity
			_play_anim_if_not_playing("cat_library/jump")

	# Bewegung anwenden
	velocity = cat_velocity
	move_and_slide()

func _play_anim_if_not_playing(anim_name: String) -> void:
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)
