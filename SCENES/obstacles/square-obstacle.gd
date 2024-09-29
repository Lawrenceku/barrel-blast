#extends KinematicBody2D
#
#export var rotation_speed = 5
#export var max_speed = 150  # Maximum speed
#export var acceleration = 200  # Acceleration rate
#export var deceleration = 300  # Deceleration rate
#export var move_range = 100  # Maximum distance to move from the initial position
#export var is_moving = true  # Whether the object is moving or not
#export(int, "None", "Left/Right", "Up/Down", "Both") var move_axis = 1  # Direction of movement
#export(int, -1, 1, 2) var move_direction_x = 1  # 1 for right, -1 for left
#export(int, -1, 1, 2) var move_direction_y = 1  # 1 for down, -1 for up
#
#var initial_position = Vector2()  # To store the initial position
#var velocity = Vector2.ZERO  # Current velocity
#
#func _ready():
#	initial_position = position
#
#func _physics_process(delta):
#	# Handle rotation
#	rotation += rotation_speed * delta
#
#	if is_moving:
#		var input = Vector2.ZERO
#
#		# Calculate input based on selected axis
#		if move_axis in [1, 3]:  # Left/Right or Both
#			input.x = move_direction_x
#		if move_axis in [2, 3]:  # Up/Down or Both
#			input.y = move_direction_y
#
#		# Apply acceleration
#		if input.length() > 0:
#			velocity = velocity.move_toward(input * max_speed, acceleration * delta)
#		else:
#			# Apply deceleration when there's no input
#			velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
#
#		# Check if the node has reached the boundary of the move range
#		var new_position = position + velocity * delta
#		if abs(new_position.x - initial_position.x) > move_range:
#			move_direction_x *= -1
#			velocity.x = 0
#		if abs(new_position.y - initial_position.y) > move_range:
#			move_direction_y *= -1
#			velocity.y = 0
#
#		# Update the node's position with the new calculated velocity
#		move_and_slide(velocity)



#extends KinematicBody2D
#
#export var rotation_speed = 5
#export var max_speed = 150  # Maximum speed
#export var acceleration = 200  # Acceleration rate
#export var deceleration = 300  # Deceleration rate
#export var move_range = 100  # Maximum distance to move from the initial position
#export var is_moving = true  # Whether the object is moving or not
#export(int, "None", "Left/Right", "Up/Down", "Both", "Arc") var move_type = 1  # Direction of movement
#export(int, -1, 1, 2) var move_direction_x = 1  # 1 for right, -1 for left
#export(int, -1, 1, 2) var move_direction_y = 1  # 1 for down, -1 for up
#
## Arc movement properties
#export var arc_radius = 100  # Radius of the arc
#export var arc_angle_range = 90  # Total angle range of the arc in degrees
#export var arc_speed = 2  # Speed of movement along the arc
#
#var initial_position = Vector2()  # To store the initial position
#var velocity = Vector2.ZERO  # Current velocity
#var current_arc_angle = 0  # Current angle within the arc
#var arc_direction = 1  # Direction of arc movement (1 for clockwise, -1 for counter-clockwise)
#
#func _ready():
#	initial_position = position
#
#func _physics_process(delta):
#	# Handle rotation
#	rotation += rotation_speed * delta
#
#	if is_moving:
#		match move_type:
#			0:  # None
#				pass
#			1, 2, 3:  # Left/Right, Up/Down, or Both
#				_handle_linear_movement(delta)
#			4:  # Arc
#				_handle_arc_movement(delta)
#
#func _handle_linear_movement(delta):
#	var input = Vector2.ZERO
#
#	# Calculate input based on selected axis
#	if move_type in [1, 3]:  # Left/Right or Both
#		input.x = move_direction_x
#	if move_type in [2, 3]:  # Up/Down or Both
#		input.y = move_direction_y
#
#	# Apply acceleration
#	if input.length() > 0:
#		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
#	else:
#		# Apply deceleration when there's no input
#		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
#
#	# Check if the node has reached the boundary of the move range
#	var new_position = position + velocity * delta
#	if abs(new_position.x - initial_position.x) > move_range:
#		move_direction_x *= -1
#		velocity.x = 0
#	if abs(new_position.y - initial_position.y) > move_range:
#		move_direction_y *= -1
#		velocity.y = 0
#
#	# Update the node's position with the new calculated velocity
#	move_and_slide(velocity)
#
#func _handle_arc_movement(delta):
#	# Update current angle
#	current_arc_angle += arc_speed * arc_direction * delta
#
#	# Check if we've reached the angle limits
#	if abs(current_arc_angle) >= deg2rad(arc_angle_range / 2):
#		arc_direction *= -1  # Reverse direction
#		current_arc_angle = sign(current_arc_angle) * deg2rad(arc_angle_range / 2)  # Clamp to limit
#
#	# Calculate new position on the arc
#	var offset = Vector2(
#		cos(current_arc_angle) * arc_radius,
#		sin(current_arc_angle) * arc_radius
#	)
#
#	# Update position
#	position = initial_position + offset
#
#func set_movement_type(type):
#	move_type = type
#	# Reset position when changing movement type
#	position = initial_position
#	velocity = Vector2.ZERO
#	current_arc_angle = 0
#
#func set_arc_parameters(radius, angle_range, speed):
#	arc_radius = radius
#	arc_angle_range = angle_range
#	arc_speed = speed
#	# Reset arc movement
#	current_arc_angle = 0
#	arc_direction = 1

extends KinematicBody2D

export var rotation_speed = 5
export var max_speed = 150  # Maximum speed
export var acceleration = 200  # Acceleration rate
export var deceleration = 300  # Deceleration rate
export var move_range = 100  # Maximum distance to move from the initial position
export var is_moving = true  # Whether the object is moving or not
export(int, "None", "Left/Right", "Up/Down", "Both", "Arc") var move_type = 1  # Direction of movement
export(int, -1, 1, 2) var move_direction_x = 1  # 1 for right, -1 for left
export(int, -1, 1, 2) var move_direction_y = 1  # 1 for down, -1 for up

# Arc movement properties
export var arc_radius = 100  # Radius of the arc
export var arc_from_angle = 0  # Starting angle of the arc in degrees
export var arc_to_angle = 90  # Ending angle of the arc in degrees
export var arc_speed = 90  # Speed of movement along the arc in degrees per second

var initial_position = Vector2()  # To store the initial position
var velocity = Vector2.ZERO  # Current velocity
var current_arc_angle = 0  # Current angle within the arc
var arc_direction = 1  # Direction of arc movement (1 for clockwise, -1 for counter-clockwise)

func _ready():
	initial_position = position
	current_arc_angle = deg2rad(arc_from_angle)

func _physics_process(delta):
	# Handle rotation
	rotation += rotation_speed * delta
	
	if is_moving:
		match move_type:
			0:  # None
				pass
			1, 2, 3:  # Left/Right, Up/Down, or Both
				_handle_linear_movement(delta)
			4:  # Arc
				_handle_arc_movement(delta)

func _handle_linear_movement(delta):
	var input = Vector2.ZERO
	
	# Calculate input based on selected axis
	if move_type in [1, 3]:  # Left/Right or Both
		input.x = move_direction_x
	if move_type in [2, 3]:  # Up/Down or Both
		input.y = move_direction_y
	
	# Apply acceleration
	if input.length() > 0:
		velocity = velocity.move_toward(input * max_speed, acceleration * delta)
	else:
		# Apply deceleration when there's no input
		velocity = velocity.move_toward(Vector2.ZERO, deceleration * delta)
	
	# Check if the node has reached the boundary of the move range
	var new_position = position + velocity * delta
	if abs(new_position.x - initial_position.x) > move_range:
		move_direction_x *= -1
		velocity.x = 0
	if abs(new_position.y - initial_position.y) > move_range:
		move_direction_y *= -1
		velocity.y = 0
	
	# Update the node's position with the new calculated velocity
	move_and_slide(velocity)

func _handle_arc_movement(delta):
	# Update current angle
	var angle_change = deg2rad(arc_speed) * arc_direction * delta
	current_arc_angle += angle_change
	
	# Check if we've reached the angle limits
	var from_rad = deg2rad(arc_from_angle)
	var to_rad = deg2rad(arc_to_angle)
	var min_angle = min(from_rad, to_rad)
	var max_angle = max(from_rad, to_rad)
	
	if current_arc_angle <= min_angle or current_arc_angle >= max_angle:
		arc_direction *= -1  # Reverse direction
		current_arc_angle = clamp(current_arc_angle, min_angle, max_angle)
	
	# Calculate new position on the arc
	var offset = Vector2(
		cos(current_arc_angle) * arc_radius,
		sin(current_arc_angle) * arc_radius
	)
	
	# Update position
	position = initial_position + offset

func set_movement_type(type):
	move_type = type
	# Reset position when changing movement type
	position = initial_position
	velocity = Vector2.ZERO
	current_arc_angle = deg2rad(arc_from_angle)

func set_arc_parameters(radius, from_angle, to_angle, speed):
	arc_radius = radius
	arc_from_angle = from_angle
	arc_to_angle = to_angle
	arc_speed = speed
	# Reset arc movement
	current_arc_angle = deg2rad(arc_from_angle)
	arc_direction = 1 if arc_to_angle > arc_from_angle else -1
