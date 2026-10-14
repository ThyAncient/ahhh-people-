extends Node

@onready var camera_2d: Camera2D = $"../Camera2D"
@onready var gamemanager = Gamemanager
var is_shaking: bool = false
var shake_intensity: float = 0.1  # Increase for stronger shake
var shake_duration: float = 0.2
var shake_timer: float = 0.0
var cameraposition: Vector2  # Stores original camera position

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Entity"):
		print("Hey I'm Shaking")
		is_shaking = true
		shake_timer = shake_duration

func _process(delta: float) -> void:
	shake_intensity = gamemanager.addShakeMultiplier
	if is_shaking:
		shake_camera(delta)

func shake_camera(delta: float) -> void:
	if shake_timer > 0:
		cameraposition = camera_2d.offset
		shake_timer -= delta

		# Random zoom effect
		var random_zoom = randf_range(3.0, 2.5)
		camera_2d.zoom = Vector2(random_zoom, random_zoom)
		
		# Apply random shake around initial camera position
		var random_offsetx = randf_range(-5, 10)
		var random_offsety = randf_range(2, -6)
		camera_2d.offset = Vector2(random_offsetx, random_offsety) + cameraposition
	else:
		# Stop shaking and reset camera
		camera_2d.zoom = Vector2(2.5, 2.5)  # Reset zoom to default
		camera_2d.offset = Vector2(0, 200)
		is_shaking = false
