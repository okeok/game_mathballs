extends Node2D

func _ready():
	get_node("HBoxContainer/playerNumber").text = Global.mainBallNumber as String

