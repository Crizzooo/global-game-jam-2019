extends Position2D


onready var parent = get_parent()

func _ready():
	update_pivot_angle()
	
func _physics_process(delta):
	update_pivot_angle()
	
func update_pivot_angle():
	if (parent.look_direction.x != 0 or parent.look_direction.y != 0):
		print('Look direction: ', parent.look_direction)
		print('Rotation: ', rotation)
	
	var camera_look_dir = parent.look_direction
	clamp(camera_look_dir.x, -1, 1)
	clamp(camera_look_dir.y, -1, 1)
		
	rotation = camera_look_dir.angle()

