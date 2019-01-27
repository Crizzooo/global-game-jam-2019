extends Node2D

var fire_timer = 0
var fire_interval = 0.1
func _ready():
	pass

func fire_bullet(start_position, target_pos):
	if fire_timer >= fire_interval:
		fire_timer -= fire_interval
		var Bullet = preload("res://Bullet.tscn")
		var bullet_instance = Bullet.instance()
		bullet_instance.BULLET_SPEED = 2000
		bullet_instance.init_direction($BulletTarget.global_position, target_pos)
		get_tree().get_root().add_child(bullet_instance)

func _process(delta):
	if fire_timer < fire_interval:
		fire_timer += delta