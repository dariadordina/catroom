extends Node
class_name GameState

var current_player : Node = null
var players : Array = []

var switch_cooldown := 120.0 # Sekunden
var time_left := 0.0

var is_sleeping := false

func _process(delta: float):
	if time_left > 0.0:
		time_left -= delta
		
