extends KinematicBody2D

# Cannon properties
export var aim_speed = 2.5
export var min_angle = -90.0  # -90 degrees to the left
export var max_angle = 90.0   # 90 degrees to the right

# Movement properties
export var rotation_speed = 2
export var max_speed = 150  # Maximum speed
export var acceleration = 200  # Acceleration rate
export var deceleration = 300  # Deceleration rate
export var move_range = 100  # Maximum distance to move from the initial position
export var is_moving = false  # Whether the object is moving or not
export(int, "None", "Left/Right", "Up/Down", "Both") var move_axis = 1  # Direction of movement
export(int, -1, 1, 2) var move_direction_x = 1  # 1 for right, -1 for left
export(int, -1, 1, 2) var move_direction_y = 1  # 1 for down, -1 for up
export var move_only_when_active = false  # New property to control movement based on activity

var current_angle = 0
var aiming_right = true
var initial_position = Vector2()
var velocity = Vector2.ZERO
var tween:Tween
# Signal for shooting
signal shot_fired

# References to the player or any object to be shot
var player = null
var oldParent = null
var has_ball = false

func _ready():
	tween = $Tween
	initial_position = position
	current_angle = rotation
	$Polygon2D.visible = false  # Hide the polygon initially

func _physics_process(delta):
	# Handle rotation
	rotation += rotation_speed * delta

	# Handle aiming
	_aim(delta)

	# Handle movement
	if is_moving and (!move_only_when_active or has_ball):
		_move(delta)

	# Handle shooting input
	if has_ball and Input.is_action_just_pressed("shoot"):
		shoot()

# Function to handle aiming logic within the specified angle range
func _aim(delta):
	if aiming_right:
		current_angle += aim_speed * delta
		if current_angle >= deg2rad(max_angle):
			current_angle = deg2rad(max_angle)
			aiming_right = false
	else:
		current_angle -= aim_speed * delta
		if current_angle <= deg2rad(min_angle):
			current_angle = deg2rad(min_angle)
			aiming_right = true

	# Update the rotation to follow the current angle
	rotation = current_angle

# Function to handle movement
func _move(delta):
	var input = Vector2.ZERO

	# Calculate input based on selected axis
	if move_axis in [1, 3]:  # Left/Right or Both
		input.x = move_direction_x
	if move_axis in [2, 3]:  # Up/Down or Both
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

	move_and_slide(velocity)


func shoot():
	if has_ball:
		var adjusted_angle = rotation - PI / 2
		var shoot_direction = Vector2(cos(adjusted_angle), sin(adjusted_angle)).normalized() 
		if player.has_method("shoot_in_direction"):  
			player.shoot_in_direction(shoot_direction)  
			emit_signal("shot_fired")
			has_ball = false
			print("hii")     
			rmv_child(player)  
			yield(get_tree().create_timer(0.4), 'timeout')  
			if player and is_instance_valid(self):
				_remove_cannon_popup() 
		else:
			print("Player does not have method 'shoot_in_direction'")

func _on_CannonArea_area_entered(area):
	has_ball = true
	player = area.get_parent() 
	get_tree().get_nodes_in_group('main')[0].collect_barrel()
	if player:
		reparent(player)
		player.global_position = self.global_position 
		if player.has_method("stop_movement"):  
			player.stop_movement()  
		$Polygon2D.visible = true
	else:
		print("No valid player entered the cannon area")

func reparent(player):
	if player.get_parent() != self:  
		oldParent = player.get_parent()
		oldParent.remove_child(player)
		self.add_child(player)
		player.global_position = self.global_position  

func rmv_child(player):
	if player.get_parent() == self:
		print('hiii')
		self.remove_child(player)
		get_tree().get_root().add_child(player)

func _on_CannonArea_area_exited(area):
	if area.get_parent() == player:
		has_ball = false
		player = null
		$Polygon2D.visible = false

func _start_cannon_popup():
	# Animate the cannon's scale from (0, 0) to (1, 1) over 0.5 seconds (pop-up effect)
	tween.interpolate_property(self, "scale", Vector2(0, 0), Vector2(1, 1), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)

	# Start the tween
	tween.start()

func _remove_cannon_popup():
	# Animate the cannon's scale from (1, 1) to (0, 0) over 0.5 seconds (pop-up effect)
	tween.interpolate_property(self, "scale", Vector2(1, 1), Vector2(0, 0), 0.5, Tween.TRANS_BACK, Tween.EASE_OUT)

	# Connect the tween's "tween_completed" signal to call the _on_tween_completed function
	tween.connect("tween_completed", self, "_on_tween_completed")

	# Start the tween
	tween.start()

func _on_tween_completed(object, key):
	queue_free()

func _on_VisibilityNotifier2D_screen_entered():
	_start_cannon_popup()

