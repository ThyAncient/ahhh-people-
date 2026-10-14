extends Node

@onready var gamemanager = Gamemanager
@onready var sanity_sprite: AnimatedSprite2D = $"../sanitybar"
@onready var frenzy_sprite: AnimatedSprite2D = $"../frenzybar"
@onready var darkness_visual: AnimatedSprite2D = $"../darknessVisual"
@onready var slider: HSlider = $"../Control/slider"
@onready var shake_zone: Area2D = $Player/ShakeZone

func _process(delta: float) -> void:
	update_sanity_bar()
	update_frenzy_bar()
	update_darkness_bar()

func update_sanity_bar():
	if sanity_sprite and gamemanager:
		if gamemanager.sanity_bar <= 5:
			# Load the texture correctly and replace the grabber icon
			var new_icon = load("res://Sprites/SadSanityBar_sprite.png") as CompressedTexture2D
			slider.add_theme_icon_override("grabber", new_icon)
			slider.add_theme_icon_override("grabber_highlight", new_icon)
			slider.add_theme_icon_override("grabber_disabled", new_icon)
			
			var grabber_area_style = StyleBoxFlat.new()
			grabber_area_style.bg_color = Color(0.26, 0.04, 0.41, 1)  # Red color (RGBA)
			grabber_area_style.border_color = Color(0.80, 0.80, 0.80, 0.00)  # Red color (RGBA)
			grabber_area_style.border_width_bottom = 3
			slider.add_theme_stylebox_override("grabber_area", grabber_area_style)
			
		else:
			var new_icon = load("res://Sprites/HappySanityBar_sprite.png") as CompressedTexture2D
			slider.add_theme_icon_override("grabber", new_icon)
			slider.add_theme_icon_override("grabber_highlight", new_icon)
			slider.add_theme_icon_override("grabber_disabled", new_icon)
			
			var grabber_area_style = StyleBoxFlat.new()
			grabber_area_style.bg_color = Color(0.88, 0.63, 0.82, 1)  # Red color (RGBA)
			grabber_area_style.border_color = Color(0.80, 0.80, 0.80, 0.00)  # Red color (RGBA)
			grabber_area_style.border_width_bottom = 3
			slider.add_theme_stylebox_override("grabber_area", grabber_area_style)
		slider.value = gamemanager.sanity_bar

func update_frenzy_bar():
	if frenzy_sprite and gamemanager:
		if gamemanager.frenzy_bar >= 5:
			var new_icon = load("res://Sprites/DevilSanityBar_sprite.png") as CompressedTexture2D
			slider.add_theme_icon_override("grabber", new_icon)
			slider.add_theme_icon_override("grabber_highlight", new_icon)
			slider.add_theme_icon_override("grabber_disabled", new_icon)
		frenzy_sprite.frame = gamemanager.frenzy_bar
func update_darkness_bar():
	if darkness_visual and gamemanager:
		darkness_visual.frame = gamemanager.darkness_bar
