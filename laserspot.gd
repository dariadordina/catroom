extends Node3D

@export var lifetime: float = 60.0
@export var min_speed: float = 2.0
@export var max_speed: float = 10.0
@export var min_pause: float = 0.1
@export var max_pause: float = 0.4
@export var min_jump_distance: float = 1.0
@export var max_jump_distance: float = 2.0

var timer := 0.0
var paused := false
var pause_timer := 0.0
var move_speed := 2.0
var target_pos := Vector3.ZERO

var area_origin := Vector3.ZERO
var area_extents := Vector3.ONE

# Setup wird jetzt start_laser() genannt
func start_laser(area_node: MeshInstance3D):
	print("🎯 LaserSpot aktiviert")
	global_transform.origin = area_origin
	visible = true
	set_process(true)
	timer = 0.0
	paused = false
	pause_timer = 0.0
	move_speed = 3.0

	var aabb = area_node.get_mesh().get_aabb()
	print("📏 AABB:", aabb.size, "Scale:", area_node.scale)
	area_extents = aabb.size * area_node.scale * 0.5
	area_origin = area_node.global_transform.origin
	print("📍 Bereich Zentrum:", area_origin, "Extents:", area_extents)

	_set_new_target()

func _process(delta):
	if not visible:
		return

	timer += delta
	if timer > lifetime:
		print("⏳ Laser abgelaufen")
		visible = false
		set_process(false)
		return

	if paused:
		pause_timer -= delta
		if pause_timer <= 0.0:
			paused = false
			_set_new_target()
		return

	var dir = (target_pos - global_transform.origin)
	if dir.length() < 0.1:
		print("🔄 Neues Ziel nötig, weil zu nah")
		paused = true
		pause_timer = randf_range(min_pause, max_pause)
	else:
		global_translate(dir.normalized() * move_speed * delta)

func _set_new_target():
	move_speed = randf_range(min_speed, max_speed)

	var new_x = clamp(
		area_origin.x + randf_range(-area_extents.x, area_extents.x),
		area_origin.x - area_extents.x,
		area_origin.x + area_extents.x
	)

	var new_z = clamp(
		area_origin.z + randf_range(-area_extents.z, area_extents.z),
		area_origin.z - area_extents.z,
		area_origin.z + area_extents.z
	)

	target_pos = Vector3(new_x, area_origin.y, new_z)

	print("👉 Neues Ziel (geclamped):", target_pos)
