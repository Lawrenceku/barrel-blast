extends StaticBody2D

export var is_moving = false  # New option to determine if the object is moving
export var max_speed = 150  # Maximum speed
export var acceleration = 200  # Acceleration rate
export var deceleration = 300  # Deceleration rate
export var move_range_x = 100  # Maximum distance to move horizontally
export var move_range_y = 100  # Maximum distance to move vertically
export var random_scale_min = 1.5  # Minimum random scale factor
export var random_scale_max = 2.5  # Maximum random scale factor
export(int, "None", "Horizontal", "Vertical", "Both") var move_direction = 1  # Direction of movement

var random_scale_factor: float
var tween: Tween
var initial_position: Vector2
var velocity = Vector2.ZERO
export var move_direction_x = 1  # 1 for right, -1 for left
export var move_direction_y = 1  # 1 for down, -1 for up

func _ready():
	random_scale_factor = rand_range(random_scale_min, random_scale_max)
	tween = $Tween
	initial_position = position

func _physics_process(delta):
	if not is_moving:
		return  # If not moving, skip the movement logic
	
	var input = Vector2.ZERO
	
	# Calculate input based on selected direction
	match move_direction:
		1:  # Horizontal
			input.x = move_direction_x
		2:  # Vertical
			input.y = move_direction_y
		3:  # Both
			input = Vector2(move_direction_x, move_direction_y)
	
	# Apply acceleration
	if input.length() > 0:
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		# Apply deceleration when there's no input
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	# Update position
	position += velocity * delta
	
	# Check if the node has reached the boundary of the move range
	if abs(position.x - initial_position.x) > move_range_x:
		move_direction_x *= -1
		velocity.x = 0
		position.x = initial_position.x + move_range_x * sign(position.x - initial_position.x)
	
	if abs(position.y - initial_position.y) > move_range_y:
		move_direction_y *= -1
		velocity.y = 0
		position.y = initial_position.y + move_range_y * sign(position.y - initial_position.y)

func start_cannon_popup():
	# Animate the cannon's scale from (0, 0) to (random_scale_factor, random_scale_factor) over 0.5 seconds (pop-up effect)
	tween.interpolate_property(self, "scale", Vector2.ZERO, Vector2(random_scale_factor, random_scale_factor), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)
	
	# Start the tween
	tween.start()

func _on_VisibilityNotifier2D_screen_entered():
	start_cannon_popup()
