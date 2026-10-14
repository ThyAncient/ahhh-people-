extends CharacterBody2D

@onready var playerCharacterBody: CharacterBody2D = self
@onready var player_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var slide_timer: Timer = $SlideTimer
@onready var gamemanager = Gamemanager
@onready var transformation_particle: CPUParticles2D = $TransformationParticle
#AUDIO
@onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX
@onready var slide_sfx: AudioStreamPlayer2D = $SlideSFX
@onready var walk_sfx: AudioStreamPlayer2D = $WalkSFX

@onready var jump_collider: Timer = $jumpCollider

var toggle_resolvecollider = true
var can_move = true  # Controls whether the player can move
var SPEED :float
const HUMAN_SPEED = 130.0
const MONSTER_SPEED = 170.0
const MONSTER_JUMP = -300
const SLOWDOWN_SPEED = 90.0  # Speed when hit

const JUMP_VELOCITY = -320.0
const SLIDE_BURST_FORCE = 250.0  # Burst force for the slide
const DECELERATION_SPEED = 150.0  # How fast to return to regular speed after crouch
const COYOTE_TIME = 0.2  # Coyote time duration (in seconds)


# Enum for animations
enum animation {
  IDLE,
  RUN,
  JUMP,
  SLIDE,
  IDLE_MONSTER,
  RUN_MONSTER,
  Death,
  DeathEgg,
  Deathmanhole
}

# Map enum values to animation names
const ANIMATION_NAMES = {
  animation.IDLE: "BobIdleAnim",
  animation.RUN: "BobRunAnim",
  animation.JUMP: "BobJumpAnim",
  animation.SLIDE: "BobSlideAnim",
  animation.IDLE_MONSTER: "BobMonsterIdleAnim",
  animation.RUN_MONSTER: "BobMonsterRunAnim",
  animation.Death: "BobDeathAnim",
  animation.DeathEgg: "BobEggAnim",
  animation.Deathmanhole: "BobDeathManHoleAnim"
}

var is_crouching = false
var coyote_timer = 0.0  # Tracks how much time is left for coyote time
var is_monster : bool = false
#SLOWING DOWN IF GET HIT BY NET
@onready var slowdowntimer: Timer = $slowdowntimer
var is_slowed = false

func _physics_process(delta: float) -> void:
	if gamemanager.sanity_bar <= 5:
		is_monster = true
		#(not ready yet)
		#transformation_particle.emitting = true
		SPEED = MONSTER_SPEED 
	else:
		is_monster = false
		SPEED = HUMAN_SPEED
	# Apply slowdown effect
	if is_slowed:
		SPEED = SLOWDOWN_SPEED
	# Add gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Update coyote time.
	if is_on_floor():
		coyote_timer = COYOTE_TIME  # Reset coyote timer when on the ground
	else:
		coyote_timer -= delta  # Decrease timer when off the ground

	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer > 0.0 or is_crouching) and can_move:
		if is_monster:
			velocity.y = MONSTER_JUMP
		else:
			velocity.y = JUMP_VELOCITY
		jump_sfx.play()
		coyote_timer = 0.0  # Use up coyote time when jumping
		if is_crouching:
			end_slide()

	# Get the input direction.
	var direction := Input.get_axis("move_left", "move_right")
	if velocity == Vector2.ZERO :
		collision_shape.position.x = 1
		collision_shape.scale.y = 1.00
		collision_shape.position.y = 2
	if is_crouching:
		# Prevent reversing direction while sliding
		velocity.x = move_toward(velocity.x, 0, DECELERATION_SPEED * delta)
	else:
		if direction:

			velocity.x = direction * SPEED
		else:
			
			velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip the character sprite based on movement direction.
	if not is_crouching:  # Allow sprite flipping only when not crouching/sliding
		if direction > 0:
			player_sprite.flip_h = false
			if coyote_timer >= 0.0:
				collision_shape.position.x = 9
		elif direction < 0:
			if coyote_timer >= 0.0:
				collision_shape.position.x = -9
			player_sprite.flip_h = true

	# Play animations based on movement state.
	if is_on_floor() and can_move:
		if is_monster:
			if direction == 0:
				play_animation(animation.IDLE_MONSTER)
			else:
				play_animation(animation.RUN_MONSTER)
		else:
			if is_crouching:
				play_animation(animation.SLIDE)
			elif direction == 0:
				play_animation(animation.IDLE)
			else:
				play_animation(animation.RUN)
	else:
		if not is_monster and can_move:
			play_animation(animation.JUMP)

	# Handle crouch/slide mechanics.
	# Only allow sliding if player is moving (velocity.x != 0)
	if Input.is_action_just_pressed("crouch") and not is_crouching and is_on_floor() and velocity.x != 0 and not is_monster:
		start_slide(direction)
		slide_sfx.play()
	
	if not can_move:
		velocity = Vector2.ZERO  # Stop all movement
		return  # Prevents movement logic from running
	else:
		move_and_slide()

func apply_slowdown():
	if not is_slowed:
		is_slowed = true
		slowdowntimer.start()

func play_animation(animation: int) -> void:
	# Play the animation corresponding to the enum value
	var animation_name = ANIMATION_NAMES.get(animation, "")
	if animation_name != "" and player_sprite.animation != animation_name:
		player_sprite.play(animation_name)

func start_slide(direction: float) -> void:
	# Begin sliding
	is_crouching = true
	slide_timer.start()
	collision_shape.position.y = 13.5
	collision_shape.scale.y = 0.5

	# Only apply burst force once in the slide direction
	if direction != 0:
		velocity.x = direction * SLIDE_BURST_FORCE

func end_slide() -> void:
	# End sliding
	is_crouching = false
	slide_timer.stop()  # Stop the timer if jumping cancels the slide
	collision_shape.position.y = 2
	collision_shape.scale.y = 1

func _on_slide_timer_timeout() -> void:
	# End sliding when timer runs out
	end_slide()


func _on_slowdowntimer_timeout() -> void:
	is_slowed = false


func disable_movement():
	can_move = false  # Function to disable movement
	play_animation(animation.IDLE)
	play_animation(animation.Deathmanhole)

func enable_movement():
	can_move = true
	play_animation(animation.IDLE)
