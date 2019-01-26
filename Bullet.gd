extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export var BULLET_SPEED = 100
var initial_velocity = Vector2()

func _ready(initial_velocity):
	pass

func init_direction(start_vel):
	rotation = start_vel.angle()
	initial_velocity = start_vel.normalized() * BULLET_SPEED

func _process(delta):
	position += initial_velocity * delta

