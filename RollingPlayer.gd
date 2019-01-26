extends Node2D

export (int) var speed
export (int) var roll_speed
export (float) var roll_time
export (int) var roll_delay

var screensize

var is_rolling = null
var can_roll = null
var Roll_Timer = null
var Roll_Delay_Timer = null
var roll_velocity = null

var look_direction = Vector2(1, 0)

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

func _process(delta):

	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1

	look_direction = velocity
	
	# if directions are given
	if velocity.length() > 0 && !is_rolling:
		# are they starting a roll?
		if (Input.is_action_just_pressed('roll') && can_roll):
			start_roll()
			roll_velocity = velocity * roll_speed
		else:
			velocity = velocity.normalized() * speed
			$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()

	if is_rolling:
		position += roll_velocity * delta
	else:
		position += velocity * delta
		
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)


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