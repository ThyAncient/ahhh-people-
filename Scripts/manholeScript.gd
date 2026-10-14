extends Area2D
@onready var gamemanager = Gamemanager
@onready var manhole_death_screen: AnimatedSprite2D = $"../../manHoleDeathScreen/AnimatedSprite2D"
@onready var origin: Node2D = $Origin
@onready var timer: Timer = $Timer
@onready var respawn_anchor: Node2D = $"../../RespawnAnchor"
var Player_Ref
@onready var deathsound: AudioStreamPlayer2D = $deathsound
@onready var suburb_music: AudioStreamPlayer2D = $"../../SuburbMusic"

func _ready():
	if respawn_anchor:
		print("RespawnAnchor found!")
	else:
		print("RespawnAnchor not found!")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Player_Ref = body
		body.global_position.x = origin.global_position.x
		body.disable_movement()  # Call function to stop movement
		suburb_music.stop()
		deathsound.play()
		manhole_death_screen.speed_scale = 1
		manhole_death_screen.play("ManholeDeathScreenAnim")
		respawn_anchor.reset_stage01_entities()
		timer.start()

func _on_timer_timeout() -> void:
	suburb_music.play()
	Player_Ref.enable_movement()
	gamemanager.rest_bars()
	manhole_death_screen.speed_scale = -1
	manhole_death_screen.play("ManholeDeathScreenAnim")
	respawn_anchor.respawn_player()
	timer.wait_time = 1.5
