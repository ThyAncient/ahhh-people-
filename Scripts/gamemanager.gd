extends Node

var sanity_bar = 10
var frenzy_bar = 0
var darkness_bar = 0
var addShakeMultiplier = 0
func add_point():
	# Handle sanity and frenzy updates
	if sanity_bar > 0:
		sanity_bar -= 1  # Decrease sanity
		addShakeMultiplier += 1
	else:  # When sanity reaches 0, increase frenzy
		frenzy_bar += 1  
	# Once frenzy_bar reaches 10, start increasing darkness_bar
	if frenzy_bar >= 10:
		darkness_bar += 1
	else : 
		darkness_bar  = 0
	# Check for game-over condition
	if darkness_bar >= 12:
		get_tree().reload_current_scene()
		rest_bars()

func getting_shot():
	sanity_bar -= 1
	add_point()

func rest_bars():
	sanity_bar = 10
	frenzy_bar = 0
	darkness_bar = 0
	#darkness_visual.frame = 0  # Reset animation
