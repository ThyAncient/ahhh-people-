extends ParallaxBackground

@export var scroll_speed: float = 10.0  # Adjusts the background scroll speed


@onready var player: CharacterBody2D = $"../Player"

# Last tracked X position of the player
var last_player_x: float = 0.0

func _ready() -> void:
	if player:
		last_player_x = player.position.x

func _process(delta: float) -> void:
	if player:
		var player_delta_x = player.position.x - last_player_x
		last_player_x = player.position.x
		
		# Adjust the scroll offset based on player's movement
		scroll_offset.x += player_delta_x * scroll_speed
