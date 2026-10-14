extends Node2D
@onready var control: Control = $"../CanvasLayer/Control"
@onready var suburb_music: AudioStreamPlayer2D = $"../SuburbMusic"
var toggle_setting = false
# Called when the node enters the scene tree for the first time.
@onready var city_music: AudioStreamPlayer2D = $"../CityMusic"

func _ready() -> void:
	if get_tree().current_scene.name == "Stage01":
		suburb_music.play()
	elif get_tree().current_scene.name == "Stage_02":
		city_music.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_setting = !toggle_setting
		setting_Toggle()
	
	

func setting_Toggle():
	control.visible = toggle_setting
	if toggle_setting:
		if get_tree().current_scene.name == "Stage01":
			suburb_music.playing = false
		elif get_tree().current_scene.name == "Stage_02":
			city_music.playing = false
		Engine.time_scale = 0
	else:
		if get_tree().current_scene.name == "Stage01":
			suburb_music.playing = true
		elif get_tree().current_scene.name == "Stage_02":
			city_music.playing = true
		Engine.time_scale = 1

func resume():
	toggle_setting = !toggle_setting
	control.visible = toggle_setting
	if get_tree().current_scene.name == "Stage01":
			suburb_music.playing = true
	elif get_tree().current_scene.name == "Stage_02":
			city_music.playing = true
	Engine.time_scale = 1
