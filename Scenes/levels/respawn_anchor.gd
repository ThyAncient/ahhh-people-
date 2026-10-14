extends Node2D
@export var player_scene: CharacterBody2D
@export var Level_Scene: PackedScene
@onready var gamemanager = Gamemanager
@onready var timer: Timer = $Timer



func respawn_player():
	var new_player = player_scene
	new_player.global_position = global_position  # Spawn at the anchor’s position

func reset_stage01_entities():
	# Find the existing Level node
	var levelnode = get_tree().current_scene.find_child("Level", true, false)
	if levelnode:
		print("Level found, deleting...")
		levelnode.queue_free()  # Remove the old level
		timer.start()


func _on_timer_timeout() -> void:
	var new_entites = preload("res://Scenes/Level.tscn").instantiate()
	if new_entites:
		print("New Level instantiated, adding to scene...")
		get_tree().current_scene.add_child(new_entites)  # Add to the main scene
		new_entites.name = "Level"  # Ensure the name is consistent
		timer.wait_time = 0.5
		print("New Level added!")
	else:
		print("ERROR: Level instantiation failed!")
	pass # Replace with function body.
