extends Node


func _ready():
	var level_size = $"Level/world-background".texture.get_size()
	$RollingPlayer.set_bounds(level_size)
	
