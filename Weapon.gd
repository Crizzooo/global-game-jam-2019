extends Node



func _ready():
	pass

func fire_bullet(start_position, target_pos):
	var Bullet = preload("res://Bullet.tscn")
	var bullet_instance = Bullet.instance()
	# start from player position 
	# shoot towards target position
	print('what is bullet instance', bullet_instance)
	bullet_instance.init_direction(start_position, target_pos)
	get_tree().get_root().add_child(bullet_instance)
