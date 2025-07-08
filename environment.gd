extends Node3D

# NODES
@onready var sun = $Sun
@onready var moon = $Moon
@onready var env = $WorldEnvironment.environment

# SETTINGS
var day_length := 50.0 # 600 sec = 24 h
var time_of_day := 0.0  

func _process(delta: float) -> void:

	time_of_day += delta
	if time_of_day > day_length:
		time_of_day = 0.0

	var day_percent = time_of_day / day_length # 0.0 - 1.0

	var sun_angle = lerp(-180.0, 180.0, day_percent) # -90 = Sonnenaufgang
	sun.rotation.x = deg_to_rad(sun_angle)

	# 3) Lichtintensität: Sonne geht auf/unter
	var sun_strength
	if day_percent > 0.52 and day_percent < 0.98: #cutoff
		sun_strength = 0
		sun.light_energy = 0
	else:
		sun_strength = clamp(sin(day_percent * TAU), 0.0, 1.0)
		sun.light_energy = 1 + sun_strength

	var warm_sun_color = Color(1.0, 0.7, 0.5)
	var midday_sun_color = Color(1.0, 0.9, 0.8)
	sun.light_color = warm_sun_color.lerp(midday_sun_color, sun_strength)

	# 4) Mond: immer über Horizont, gegenläufig, aber fixiert
	
	moon.rotation.x = deg_to_rad(sun_angle + 180.0)
	var moon_strength
	
	if day_percent <= 0.54 and day_percent < 0.98:  #cutoff
		moon_strength = 0
		moon.light_energy = 0
	else:
		moon_strength = 0.4 * clamp(sin(day_percent * TAU), 0.0, 1.0)
		moon.light_energy = 1 + moon_strength

	#moon.light_color = Color(0.6, 0.7, 1.0) 

	# 5) Ambient Light: Nacht dunkler, Tag heller
	env.ambient_light_energy = clamp(0.1 + sun_strength * 3, 0.1, 1.0)
	
	var sky = env.sky
	var sky_material = sky.sky_material
	sky_material.sky_top_color = Color(1.0,0.6,0.7)


	# DEBUG OUTPUT
	#print("Time:", day_percent, " Sun:", sun_strength, " Sun energy", sun.light_energy, " Moon:", moon_strength, " Moon energy", moon.light_energy )
