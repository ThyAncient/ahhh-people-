extends Node2D

const speed = 60

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_right_down: RayCast2D = $RayCastRightDown
@onready var ray_cast_left_down: RayCast2D = $RayCastLeftDown
@onready var people_sprite: AnimatedSprite2D = $"./AnimatedSprite2D"
@onready var direction: int = 1  # 1 for right, -1 for left
@onready var random_timer: Timer = $RandomTimer

func _ready():
	random_timer.wait_time = 3.0
	random_timer.one_shot = false
	random_timer.start()
	random_timer.timeout.connect(_change_random_direction)

func _process(delta: float) -> void:
	if direction == 0:
		people_sprite.play("PeopleIdle")
	else:
		people_sprite.play("PeopleWalk")
	
	if direction == -1:
		people_sprite.flip_h = true
	elif direction == 1:
		people_sprite.flip_h = false
		
	# Collision detection for walls and edges
	if ray_cast_right.is_colliding() or !ray_cast_right_down.is_colliding():
		direction = -1
		people_sprite.flip_h = true
	elif ray_cast_left.is_colliding() or !ray_cast_left_down.is_colliding():
		direction = 1
		people_sprite.flip_h = false
		
	position.x += direction * speed * delta

func _change_random_direction():
	if randi() % 2 == 0:
		direction = -direction
		people_sprite.flip_h = !people_sprite.flip_h
