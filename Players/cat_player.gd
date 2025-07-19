extends PlayerBase

@onready var anim_player = $Cat2/AnimationPlayer

# Animationen als Konstanten
const ANIM = {
	"idle": "cat_library/idle",
	"walk": "cat_library/walk",
	"run": "cat_library/run",
	"jump": "cat_library/jump"
}

func _ready():
	init_camera_pivots($TwistPivot, $TwistPivot/PitchPivot, $TwistPivot/PitchPivot/Camera3D)
	print("📷 base_camera_position gesetzt auf:", base_camera_position)

func _process(delta):
	if not active:
		return

	update_camera_controls(delta)
		
func _physics_process(delta):
	if not active:
		return

	var input_x = Input.get_axis("move_left", "move_right")
	var input_z = Input.get_axis("move_forward", "move_back")
	var input_dir = Vector2(input_x, input_z)

	var is_moving = input_dir.length() > 0.01
	var is_running = Input.is_action_pressed("move_run")
	var current_speed = run_speed if is_running else speed

	# Kamera-Basis
	var basis = twist_pivot.global_transform.basis
	var cam_x = Vector3(basis.x.x, 0, basis.x.z).normalized()
	var cam_z = Vector3(basis.z.x, 0, basis.z.z).normalized()
	var direction = (cam_x * input_dir.x + cam_z * input_dir.y).normalized()

	# 🧠 Wichtig: velocity **immer** auf Basis von Input setzen
	velocity.x = direction.x * current_speed
	velocity.z = direction.z * current_speed

	# Spieler drehen
	if is_moving:
		var model = $Cat2
		var target_rotation = atan2(direction.x, direction.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation + PI, 0.15)

		_play_movement_anim(is_running)
	else:
		# Bewegung sanft abbremsen
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

		_play_idle_anim()

	# Gravitation + Sprung
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity
			_play_jump_anim()

	move_and_slide()
		
func _play_movement_anim(is_running: bool):
	if is_on_floor():
		_play_anim_if_not_playing(ANIM["run"] if is_running else ANIM["walk"])

func _play_idle_anim():
	if is_on_floor():
		_play_anim_if_not_playing(ANIM["idle"])

func _play_jump_anim():
	_play_anim_if_not_playing(ANIM["jump"])

func _play_anim_if_not_playing(anim_name: String) -> void:
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)
