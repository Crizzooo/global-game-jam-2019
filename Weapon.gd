extends Node

func _ready():
	pass

func fire_bullet(start_position, target_pos):
	var Bullet = preload("res://Bullet.tscn")
	var bullet_instance = Bullet.instance()
	bullet_instance.BULLET_SPEED = 1000
	bullet_instance.init_direction(start_position, target_pos)
	get_tree().get_root().add_child(bullet_instance)
