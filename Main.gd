extends Node


func _ready():
#	var level_size = $"Level/world-background".texture.get_size()
	randomize()

	var tile_scale = $Level/TileMap.scale
	var tile_quadrant_size = $Level/TileMap.cell_quadrant_size
	var tiles = Vector2(52, 26)
	var level_size = tiles * tile_scale * tile_quadrant_size
	var num_tiles = $Level/TileMap.tile_set.get_tiles_ids().size()

	var cell_id
	for x in range(-tiles.x/2, tiles.x/2):
		for y in range(-tiles.y/2, tiles.y/2):
			$Level/TileMap.set_cell(x, y, randi() % num_tiles, randi() % 2, randi() % 2, randi() % 2)

	$Level/TileMap._update_dirty_quadrants()

	$RollingPlayer.set_bounds(level_size)
	
