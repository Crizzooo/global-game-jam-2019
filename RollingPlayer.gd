extends Node2D

export (int) var speed
export (int) var roll_speed
export (float) var roll_time
export (float) var roll_delay
export (bool) var allow_controller
export (float) var controller_deadzone
export (float) var cursor_radius
export (int) var maxHP = 10

var screensize

var is_rolling = null
var can_roll = null
var Roll_Timer = null
var Roll_Delay_Timer = null
var roll_velocity = null
var collision_bounds_set = false
var bounds
var look_direction = Vector2()
var hp
var sfx_playing = false


func _ready():
	screensize = get_viewport_rect().size
	Roll_Timer = $RollTimer
	Roll_Timer.set_wait_time(roll_time)
	Roll_Delay_Timer = Timer.new()
	Roll_Delay_Timer.set_one_shot(true)
	Roll_Delay_Timer.set_wait_time(roll_delay)
	Roll_Delay_Timer.connect("timeout", self, "on_roll_ready")
	add_child(Roll_Delay_Timer)

	can_roll = true
	is_rolling = false
	
	look_direction = position + Vector2(1, 0) * cursor_radius
	self.add_child($Weapon)
	hp = maxHP
	print(self.get_path())


func set_bounds(bounds_vector):
	collision_bounds_set = true
	bounds = bounds_vector
	$"Pivot/CameraOffset/Camera2D".limit_top = 0
	$"Pivot/CameraOffset/Camera2D".limit_left = 0
	$"Pivot/CameraOffset/Camera2D".limit_right = bounds.x
	$"Pivot/CameraOffset/Camera2D".limit_bottom = bounds.y

func _process(delta):
	if hp <= 0:
		print("game over")

	var velocity = Vector2()

	if allow_controller:
		#   Joypad controls
		velocity = get_left_stick()
	else:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -= 1
		if Input.is_action_pressed("ui_down"):
			velocity.y += 1

	if Input.is_action_pressed("shoot"):
		var cursor_pos = $Cursor.get_global_position()
		var player_pos = global_position
		$Weapon.fire_bullet(global_position, cursor_pos)
		if !sfx_playing:
			$AudioStreamPlayer2D.play()
			sfx_playing = true
	else:
		if sfx_playing:
			sfx_playing = false
			$AudioStreamPlayer2D.stop()

	look_direction = velocity
	$Weapon.rotation = Vector2(-1,0).angle_to($Cursor.position)

	# if directions are given
	if velocity.length() > 0 && !is_rolling:
		# are they starting a roll?
		if (Input.is_action_just_pressed('roll') && can_roll):
			start_roll()
			roll_velocity = velocity * roll_speed
		elif is_rolling:
			roll_velocity = velocity * roll_speed
		else:
			if abs(velocity.length()) > 1:
				velocity = velocity.normalized() * speed
			else:
				velocity = velocity * speed
			$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	if is_rolling:
		position += roll_velocity * delta
	else:
		position += velocity * delta

	if velocity.x > 0:
		scale.x = -1
		#$AnimatedSprite.flip_h = true
	if velocity.x < 0:
		scale.x = 1
		#$AnimatedSprite.flip_h = false

	if collision_bounds_set:
		position.x = clamp(position.x, 0, bounds.x)
		position.y = clamp(position.y, 0, bounds.y)

	if allow_controller:
		look_direction = get_right_stick() * cursor_radius
	else:
		look_direction =  get_global_mouse_position() - global_position
		look_direction = look_direction.clamped(cursor_radius)

	if !(look_direction.x == 0 and look_direction.y == 0):
		var tmp_pos = look_direction
		tmp_pos.x *= scale.x
		$Cursor.set_position(tmp_pos)
	#$Cursor.global_position = get_global_mouse_position()

func start_roll():
	can_roll = false
	is_rolling = true
	Roll_Timer.start()
	$AnimatedSprite.stop()

func _on_RollTimer_timeout():
	is_rolling = false
	Roll_Delay_Timer.start()

func on_roll_ready():
	can_roll = true

func get_left_stick():
	var x = Input.get_joy_axis(0, JOY_AXIS_0)
	var y = Input.get_joy_axis(0, JOY_AXIS_1)
	return check_deadzone(Vector2(x, y))

func get_right_stick():
	var x = Input.get_joy_axis(0, JOY_AXIS_2)
	var y = Input.get_joy_axis(0, JOY_AXIS_3)
	return check_deadzone(Vector2(x, y))

func check_deadzone(direction):
	if abs(direction.x) < controller_deadzone:
		direction.x = 0
	if abs(direction.y) < controller_deadzone:
		direction.y = 0
	return direction
