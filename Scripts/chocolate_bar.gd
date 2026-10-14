extends Area2D

@onready var sanity_sprite: AnimatedSprite2D = %sanitybar
@onready var gamemanager = Gamemanager
@onready var pickup_sfx: AudioStreamPlayer2D = $SFX
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Lessening Sanity")
		var power_up_value = 4  # The value the chocolate power-up provides
			# Check if the sound is already playing
		if pickup_sfx.playing:
			print("Sound is still playing; no changes to sanity or frenzy.")
			return  # Exit the function early if the sound is playing
		# Apply power-up logic
		if gamemanager.frenzy_bar >= power_up_value:
			gamemanager.frenzy_bar -= power_up_value
		else:
			var remaining_value = power_up_value - gamemanager.frenzy_bar
			gamemanager.frenzy_bar = 0
			gamemanager.sanity_bar += remaining_value
			gamemanager.sanity_bar = min(gamemanager.sanity_bar, 10)  # Assuming max sanity is 10

		# Disable sprite and collision
		sprite.visible = false
		collision_shape.disabled = true
	
		# Play the pickup sound effect
		print("Playing SFX")
		pickup_sfx.play()

		# Connect the 'finished' signal to queue_free() the node after the sound is done
		pickup_sfx.finished.connect(_on_sfx_finished)

func _on_sfx_finished():
	queue_free()  # Remove the chocolate power-up completely
