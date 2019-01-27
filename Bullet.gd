extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var life_timer = 0
export var life_time = 0.5
export var BULLET_SPEED = 100
var direction

func _ready(initial_velocity):
	pass

func init_direction(start_position, target_position):
	position = start_position
	rotation = start_position.angle_to(target_position)
	direction = target_position - start_position
	direction = direction.normalized()

func _process(delta):
	global_position += direction * delta * BULLET_SPEED
	life_timer += delta
	if life_timer > life_time:
		get_parent().remove_child(self)

