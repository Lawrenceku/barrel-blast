extends KinematicBody2D

# Speed and acceleration values
var speed = 1200
var acceleration = 20000
var max_speed = 2000
var velocity = Vector2.ZERO  # Initialize to zero so it doesn't move initially
var direction = Vector2.ZERO  # No initial direction

func _physics_process(delta):
	# Handle movement and acceleration only if direction is set
	if direction != Vector2.ZERO:
		# Accelerate toward the current velocity direction
		velocity = velocity.move_toward(velocity.normalized() * max_speed, acceleration * delta)
	
	# Move the ball and check for collision
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		# Reflect the velocity based on the collision normal
		velocity = velocity.bounce(collision_info.normal)
		# Update direction to match the new velocity direction after the bounce
		direction = velocity.normalized()
		$ricochetSFX.playing = true

func shoot_in_direction(new_direction: Vector2):
	$shootSFX.playing = true
	$Camera2D.shaker()
	direction = new_direction.normalized()
	velocity = direction * speed  # Set initial movement

func stop_movement():
	velocity = Vector2.ZERO  # Reset velocity to zero
	direction = Vector2.ZERO  # Reset direction to zero

func _on_playerarea_area_entered(area):
	if area.collision_layer & (1 << 4) != 0:
		stop_movement()
		$Camera2D.highShaker()
		get_node("..").game_over()

