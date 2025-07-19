extends CharacterBody3D

#mouse
var mouse_sensitivity := 0.002 #:= static type declaration = dynamic type decl
var twist := 0.0
var pitch := 0.0
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

var active := false
var speed := 4.0

@onready var camera_pivot = $TwistPivot/PitchPivot/Camera3D

func wake_up():
	active = true
func sleep():
	active = false
	#print("HumanPlayer sleeps...")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if not active:
		return
		
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		twist -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-40), deg_to_rad(40))

func _process(_delta: float) -> void:
	if not active:
		return
	twist_pivot.rotation.y = twist
	pitch_pivot.rotation.x = pitch

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	if not active:
		return  

	var input_vector = Vector3.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.z = Input.get_axis("move_forward", "move_back")
	input_vector = input_vector.normalized()

	if input_vector != Vector3.ZERO:
		var direction = -transform.basis.z * input_vector.z + transform.basis.x * input_vector.x
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	if not is_on_floor():
		velocity.y -= 9.8 * delta
	else:
		velocity.y = 0

	move_and_slide()
