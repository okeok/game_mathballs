extends Control

func _on_game_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene("res://sceense/game.tscn")

func _ready():
	get_tree().paused = false
	get_node("background").rect_size.x = get_viewport().size.x
	get_node("background").rect_size.y = get_viewport().size.y
