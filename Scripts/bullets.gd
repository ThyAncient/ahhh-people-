extends Node2D

@export var speed: float = 300.0  # Speed of the bullet
var direction: Vector2 = Vector2.ZERO
var pistol_range := false  # Determines if the range timer should start
func _physics_process(delta: float) -> void:
	# Move the bullet in the given direction
	position += direction * speed * delta
	# Handle bullet range timeout
	if pistol_range:
		$Area2D/Timer.wait_time = 1.5  # Range limit for bullets
		$Area2D/Timer.start()
		pistol_range = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_timer_timeout() -> void:
	$Area2D/Timer.stop()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":  # Assuming the player's node is named "Player"
		var gamemanager = get_node("/root/Gamemanager")  # Reference to the Gamemanager
		gamemanager.getting_shot()  # Reduce sanity to 0
		queue_free()  # Remove the bullet
	else:
		queue_free()
