extends Node2D


@export var speed: float = 300.0  # Speed of the bullet
var direction: Vector2 = Vector2.ZERO
var net_range := false  # Determines if the range timer should start
@onready var net_sprite: Sprite2D = $Area2D/Sprite2D


func _ready() -> void:
	net_sprite.flip_v = direction.x < 0
func _process(delta: float) -> void:
	if direction.x < 0:
		net_sprite.flip_v = false
	elif direction.x > 0:
		net_sprite.flip_v = true
func _physics_process(delta: float) -> void:
	# Move the bullet in the given direction
	position += direction * speed * delta
	# Handle bullet range timeout
	if net_range:
		$Area2D/Timer.wait_time = 1.5  # Range limit for bullets
		$Area2D/Timer.start()
		net_range = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$Area2D/Timer.stop()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Assuming the player's node is named "Player"
		body.apply_slowdown()  # Call slowdown function
		queue_free()  # Remove the bullet
	else:
		queue_free()
