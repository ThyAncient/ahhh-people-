extends Control
@onready var settings_manager: Node2D = $"../../SettingsManager"

# Signal to start the game
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/levels/intro_cutscene.tscn") # Replace with your actual game scene path


# Signal to quit the game
func _on_quit_button_pressed() -> void:
	get_tree().quit()

# Signal for options (you can expand this later)
func _on_option_button_pressed() -> void:
	print("Options menu not implemented yet!") # Placeholder for options


func _on_menu_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://Scenes/levels/main_menu.tscn")


func _on_resume_pressed() -> void:
	settings_manager.resume()
