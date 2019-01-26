extends Node

var Bullet = load("res://Bullet.tscn")

func _ready():
	fire_bullet()
	pass

func fire_bullet():
	var bullet_instance = Bullet.instance()
	bullet_instance.init_direction(Vector2(1, 0))
	add_child(bullet_instance)
