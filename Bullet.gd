extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var life_timer = 0
export var life_time = 0.2
export var BULLET_SPEED = 100
export var damage = 1
var direction

# 0 is player, 1 is enemy
export (int) var bullet_tag = 0


func _ready(initial_velocity):
	pass

func init_direction(start_position, target_position):
	position = start_position
	rotation = start_position.angle_to(target_position)
	direction = target_position - start_position
	direction = direction.normalized()

func _process(delta):
	life_timer += delta
	if life_timer > life_time:
		get_parent().remove_child(self)

func _physics_process(delta):
	var col = move_and_collide(direction * delta * BULLET_SPEED)
	if col:
		#print(col.collider.position)
		var pawn = col.collider
		if pawn.get_hit(bullet_tag, damage):
			get_parent().remove_child(self)
		
#	global_position += direction * delta * BULLET_SPEED
	#prnit(get_colliding_bodies().size())