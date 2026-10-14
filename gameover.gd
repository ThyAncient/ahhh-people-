extends Node2D

@onready var gameover: Node2D = $"."


func GameOver() :

	gameover.visible = true #show the gameover screen

	get_tree().paused = true #pauses the game

func _on_restart_pressed() -> void:
	get_tree().paused = false 
	get_tree().reload_current_scene() #restart the game 
	# also i set Gameoverscreen process on when paused that's how the button works

func _on_quit_pressed() -> void:
	get_tree().quit() #quit the game when pressed
