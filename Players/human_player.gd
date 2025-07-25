extends PlayerBase

# AnimationPlayer für den Menschen
@onready var anim_player = $human/AnimationPlayer

# Animationen definieren
const ANIM = {
	"idle": "human/idle",
	"walk": "human/walking"
}

func _ready():
	init_camera_pivots($TwistPivot, $TwistPivot/PitchPivot, $TwistPivot/PitchPivot/Camera3D)
	print("📷 base_camera_position gesetzt auf:", base_camera_position)

func _process(delta):
	if not active:
		return
	
	# Kameraabstand wie bei der Katze
	var target_distance = 3.0
	var min_distance = 0.2
	#var raycast = $TwistPivot/PitchPivot/RayCast3D
	var cam = $TwistPivot/PitchPivot/Camera3D

	#if raycast.is_colliding():
		#var dist = raycast.get_collision_point().distance_to(global_transform.origin)
		#cam.position.z = -clamp(dist, min_distance, target_distance)
	#else:
	cam.position.z = -target_distance

	update_camera_controls(delta)
		
func _physics_process(delta):
	if not active:
		return

	var input_x = Input.get_axis("move_left", "move_right")
	var input_z = Input.get_axis("move_forward", "move_back")
	var input_dir = Vector2(input_x, input_z)

	var is_moving = input_dir.length() > 0.01

	# Kameraorientierung für Bewegungsrichtung
	var basis = twist_pivot.global_transform.basis
	var cam_x = - Vector3(basis.x.x, 0, basis.x.z).normalized()
	var cam_z = - Vector3(basis.z.x, 0, basis.z.z).normalized()
	var direction = (cam_x * input_dir.x + cam_z * input_dir.y).normalized()

	# Bewegung
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if is_moving:
		# Spieler in Bewegungsrichtung drehen
		var model = $human
		var target_rotation = atan2(direction.x, direction.z) + PI
		model.rotation.y = lerp_angle(model.rotation.y, target_rotation + PI, 0.15)

		_play_walk_anim()
	else:
		# sanft abbremsen
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

		_play_idle_anim()

	# Gravitation
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

	move_and_slide()

# ---------------- Animation Handling ----------------
func _play_walk_anim():
	if is_on_floor():
		_play_anim_if_not_playing(ANIM["walk"])

func _play_idle_anim():
	if is_on_floor():
		_play_anim_if_not_playing(ANIM["idle"])

func _play_anim_if_not_playing(anim_name: String) -> void:
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)
