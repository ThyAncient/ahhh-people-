extends Area2D

@onready var death_sfx: AudioStreamPlayer2D = $"../DeathSFX"
@onready var area: Area2D = $"."
@onready var cpu_particles: CPUParticles2D = $CPUParticles2D
@onready var people_sprite: AnimatedSprite2D = $"../AnimatedSprite2D" 
@onready var timer: Timer = $"../Timer"
@onready var gamemanager = Gamemanager
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var ray_casts: Array = [
	$"../RayCastRight",
	$"../RayCastLeft",
	$"../RayCastRightDown",
	$"../RayCastLeftDown"
]

var disabled = false  # Tracks if the person is already disabled

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if disabled:  # Prevent adding points if already disabled
			return
		print("You Died Particle")  # Debugging line
		gamemanager.add_point()
		death_sfx.play()
		# Hide the sprite and disable interaction
		disabled = true
		people_sprite.self_modulate.a = 0
		collision_shape.disabled = true
		# Stop all RayCast2D nodes
		for ray_cast in ray_casts:
			if ray_cast is RayCast2D:
				ray_cast.enabled = false

		# Start death effect
		cpu_particles.emitting = true

		# Start timer to queue_free
		timer.wait_time = 0.5
		timer.start()
func _on_timer_timeout() -> void:
	get_parent().queue_free()
