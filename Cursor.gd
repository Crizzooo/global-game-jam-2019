extends Node

var cursor = load("res://art/UI/cursor.png")

func _ready():
	Input.set_custom_mouse_cursor(cursor, Input.CURSOR_ARROW, Vector2(16,16))
