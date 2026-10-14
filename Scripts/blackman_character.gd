extends CharacterBody2D

@export var player: CharacterBody2D
@export var speed: float = 100.0  # Patrol movement speed
@export var chase_speed: float = 150.0  # Speed when chasing the player
@export var acceleration: int = 300
@export var idle_time: float = 1.0  # Idle duration at patrol points
@onready var blackman_sprite: AnimatedSprite2D = $BlackmanSprite
@onready var raycast: RayCast2D = $RayCast1
@onready var timer: Timer = $Timer
@export var right_bounds_position: Vector2 = Vector2(85, 0)
@export var left_bounds_position: Vector2 = Vector2(-150, 0)
@export var raycastsize: Vector2 = Vector2(75,0)
@export var raycastsize2: Vector2 = Vector2(-75,0)
@export var shootpositionspeed : float = 0.0
@onready var cpu_particles: CPUParticles2D = $hurtbox/CPUParticles2D
@onready var gamemanager = Gamemanager
@export var shoot_range: float = 50.0  # Distance to start shooting
@export var fire_rate: float = 1.0  # Time between shots
@onready var shoot_timer: Timer = $ShootTimer  # Add a Timer node for shooting
@onready var pistol_muzzle: Marker2D = $"pistol muzzle"
@onready var delaybetweenshoots: Timer = $delaybetweenshoots
@onready var net_dircetion: Marker2D = $bulletDircetion
@onready var shooting: AudioStreamPlayer2D = $shooting
@onready var death_sfx: AudioStreamPlayer2D = $DeathSFX
@onready var blackman_collision: CollisionShape2D = $BlackmanCollision
@onready var ray_cast_1: RayCast2D = $RayCast1
@onready var delay_on_death: Timer = $DelayOnDeath

var disable : bool = false


var victor:= Vector2 (100,0)
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2
var right_bounds: Vector2
var left_bounds: Vector2
var is_idle: bool = false
var can_shoot: bool = true
var shots_fired: bool = false
var is_dead: bool = false


enum States {
	PATROL,
	CHASE,
	SHOOT
}

var current_state = States.PATROL

func _ready() -> void:
	left_bounds = self.position + left_bounds_position
	right_bounds = self.position + right_bounds_position


func _physics_process(delta: float) -> void:
	if not is_idle:  # Skip movement and direction logic when idle
		handle_gravity(delta)
		handle_movement(delta)
		change_direction()
		look_for_player()
		update_gun_position()
		print(current_state)
	# Check if the player is within shooting range



func transition_to_shoot() -> void:
	if not can_shoot:
		if delaybetweenshoots.time_left <= 0:
			can_shoot = true
		else:
			return
	else:  # Stop moving
		shoot_bullet()
		shooting.play()
		delaybetweenshoots.start()  # Start the shooting timer
		can_shoot = false


func _on_delaybetweenshoots_timeout() -> void:
	can_shoot = true

func shoot_bullet() -> void:
	var net_scene = preload("res://Scenes/net.tscn")
	var bullet = net_scene.instantiate()
	if not is_dead:
		# Set the bullet's position to start at the pistol muzzle
		bullet.position = pistol_muzzle.global_position

		# Calculate the direction towards the `bullet_direction` marker
		var direction = (net_dircetion.global_position - pistol_muzzle.global_position).normalized()
		
		# Pass the direction to the bullet
		bullet.direction = direction
		
		bullet.net_range = true
		# Add the bullet to the scene
		get_parent().add_child(bullet)

func look_for_player():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player:
			end_idle_phase()
			current_state = States.SHOOT
			transition_to_shoot()
			#stop_chase()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()
	elif current_state == States.SHOOT:
		chase_player()
		

func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE
	can_shoot = false


func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()

func handle_movement(delta: float) -> void:
	if current_state == States.PATROL:
		velocity = velocity.move_toward(direction * speed, acceleration * delta)
		blackman_sprite.play("Blackman_run")
	elif current_state == States.CHASE:
		velocity = velocity.move_toward(direction * chase_speed, acceleration * delta)
		if velocity != Vector2.ZERO:
			blackman_sprite.play("Blackman_run")
	elif current_state == States.SHOOT:
		velocity = Vector2.ZERO
		if can_shoot:
			blackman_sprite.play("Blackman_idle")
		else :
			blackman_sprite.play("Blackman_idle")
		

	move_and_slide()

func change_direction() -> void:
	if current_state == States.PATROL:
		if blackman_sprite.flip_h:  # Moving right
			if self.position.x <= right_bounds.x:
				direction = Vector2(1, 0)  # Continue moving right
			else:
				start_idle_phase()
				await get_tree().create_timer(idle_time).timeout
				end_idle_phase()
				blackman_sprite.flip_h = false
				pistol_muzzle.position = raycast.target_position
				#raycast.target_position.x = 100 
				raycast.target_position = left_bounds_position  + raycastsize2
		else:  # Moving left
			if self.position.x >= left_bounds.x:
				direction = Vector2(-1, 0)  # Continue moving left
			else:
				start_idle_phase()
				await get_tree().create_timer(idle_time).timeout
				end_idle_phase()
				blackman_sprite.flip_h = true
				raycast.target_position = right_bounds_position  + raycastsize
	elif current_state == States.CHASE :
		# In chase mode, update direction to follow the player
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			blackman_sprite.flip_h = true
			raycast.target_position = right_bounds_position + raycastsize
		else:
			blackman_sprite.flip_h = false
			raycast.target_position = left_bounds_position + raycastsize2
	elif current_state == States.SHOOT:
		# In chase mode, update direction to follow the player
		direction = (player.position - self.position).normalized()
		direction = sign(direction)
		if direction.x == 1:
			blackman_sprite.flip_h = true
			raycast.target_position = right_bounds_position + raycastsize
			update_gun_position()
		else:
			blackman_sprite.flip_h = false
			raycast.target_position = left_bounds_position + raycastsize2
			update_gun_position()

func start_idle_phase() -> void:
	is_idle = true
	velocity = Vector2.ZERO  # Stop movement
	blackman_sprite.play("Blackman_idle")  # Play idle animation

func end_idle_phase() -> void:
	is_idle = false  # Resume normal behavior

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func update_gun_position():
	if blackman_sprite.flip_h:  # Facing right
		pistol_muzzle.position.x = 40
		pistol_muzzle.position.y = -2
		net_dircetion.position.x = 140
		net_dircetion.position.y = 0
	else:  # Facing left
		pistol_muzzle.position.x = -40
		pistol_muzzle.position.y = 2
		net_dircetion.position.x = -140
		net_dircetion.position.y = 0

	


func _on_timer_timeout() -> void:
	current_state = States.PATROL


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if disable:
			return
		print("ssss")
		# Start death effect
		is_dead = true
		shooting.stop()
		death_sfx.play()
		cpu_particles.emitting = true
		blackman_sprite.visible = false
		raycast.enabled = false
		can_shoot = false
		gamemanager.add_point()
		disable = true
		delay_on_death.start()

func _on_delay_on_death_timeout() -> void:
	queue_free()
